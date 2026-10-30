import 'package:milestracks/shared/models/api_models.dart';

abstract interface class ShopRepository {
  Future<List<ShopItemDto>> getCatalog();
  Future<PurchaseResultDto> purchase(
    PurchaseRequestDto request, {
    required String idempotencyKey,
  });
  Future<List<InventoryItemDto>> getInventory();
  Future<LedgerPageDto> getCoinLedger({String? cursor});
}
