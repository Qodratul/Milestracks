import 'package:milestracks/core/data/fake_data_store.dart';
import 'package:milestracks/core/data/fake_repository_behavior.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/features/shop/domain/shop_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class FakeShopRepository implements ShopRepository {
  const FakeShopRepository(this.behavior, this.store);

  final FakeRepositoryBehavior behavior;
  final FakeDataStore store;

  @override
  Future<List<ShopItemDto>> getCatalog() =>
      behavior.execute('shop.catalog', store.catalog);

  @override
  Future<PurchaseResultDto> purchase(
    PurchaseRequestDto request, {
    required String idempotencyKey,
  }) => behavior.execute('shop.purchase', () {
    final item = store.catalog().firstWhere(
      (item) => item.id == request.itemId,
    );
    if (store.coins < item.priceCoins) {
      throw const AppException(
        kind: AppExceptionKind.server,
        statusCode: 409,
        message: 'insufficientCoins',
      );
    }
    store.coins -= item.priceCoins;
    store.user = store.user.copyWith(coins: store.coins);
    store.ledger.insert(
      0,
      LedgerEntryDto(
        id: 'ledger-purchase-${store.ledger.length + 1}',
        currency: 'coin',
        amount: -item.priceCoins,
        reason: 'shop_purchase',
        refId: item.id,
        createdAt: DateTime.now().toUtc(),
      ),
    );
    final existingIndex = store.inventory.indexWhere(
      (entry) => entry.itemId == item.id,
    );
    if (existingIndex >= 0) {
      final previous = store.inventory[existingIndex];
      store.inventory[existingIndex] = previous.copyWith(
        quantity: previous.quantity + 1,
      );
    } else {
      store.inventory.add(
        InventoryItemDto(
          id: 'inventory-${item.id}',
          itemId: item.id,
          name: item.name,
          description: item.description,
          quantity: 1,
          equipped: false,
        ),
      );
    }
    return PurchaseResultDto(
      inventoryItemId: 'inventory-${item.id}',
      itemId: item.id,
      remainingCoins: store.coins,
    );
  });

  @override
  Future<List<InventoryItemDto>> getInventory() => behavior.execute(
    'shop.inventory',
    () => store.inventory
        .map((entry) {
          final item = store.catalog().firstWhere(
            (catalogItem) => catalogItem.id == entry.itemId,
          );
          return entry.copyWith(name: item.name, description: item.description);
        })
        .toList(growable: false),
  );

  @override
  Future<LedgerPageDto> getCoinLedger({String? cursor}) =>
      behavior.execute('shop.ledger', () {
        final start = cursor == null ? 0 : int.tryParse(cursor) ?? 0;
        final safeStart = start.clamp(0, store.ledger.length);
        final end = (start + 10).clamp(0, store.ledger.length);
        return LedgerPageDto(
          entries: store.ledger.sublist(safeStart, end),
          nextCursor: end < store.ledger.length ? '$end' : null,
        );
      });
}
