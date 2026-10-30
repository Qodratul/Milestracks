import 'package:milestracks/core/di/repository_providers.dart';
import 'package:milestracks/core/utils/idempotency_key.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_providers.g.dart';

@riverpod
Future<List<ShopItemDto>> shopCatalog(Ref ref) =>
    ref.watch(shopRepositoryProvider).getCatalog();

@riverpod
Future<List<InventoryItemDto>> userInventory(Ref ref) =>
    ref.watch(shopRepositoryProvider).getInventory();

@riverpod
Future<LedgerPageDto> coinLedger(Ref ref) =>
    ref.watch(shopRepositoryProvider).getCoinLedger();

@riverpod
class ShopPurchaseController extends _$ShopPurchaseController {
  @override
  Future<void> build() async {}

  Future<PurchaseResultDto?> purchase(String itemId) async {
    state = const AsyncLoading<void>();
    try {
      final result = await ref
          .read(shopRepositoryProvider)
          .purchase(
            PurchaseRequestDto(itemId: itemId),
            idempotencyKey: IdempotencyKey.create(),
          );
      state = const AsyncData<void>(null);
      ref.invalidate(shopCatalogProvider);
      ref.invalidate(userInventoryProvider);
      ref.invalidate(coinLedgerProvider);
      ref.invalidate(currentUserProvider);
      return result;
    } on Object catch (error, stackTrace) {
      state = AsyncError<void>(error, stackTrace);
      return null;
    }
  }
}
