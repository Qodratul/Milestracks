import 'package:dio/dio.dart';
import 'package:milestracks/core/network/remote_repository_base.dart';
import 'package:milestracks/features/shop/domain/shop_repository.dart';
import 'package:milestracks/shared/models/api_models.dart';

class RemoteShopRepository extends RemoteRepositoryBase
    implements ShopRepository {
  const RemoteShopRepository(super.dio, {super.cache});

  @override
  Future<List<ShopItemDto>> getCatalog() => cachedRead<List<ShopItemDto>>(
    key: 'shop:catalog',
    maxAge: const Duration(hours: 1),
    fetch: () => guard(() async {
      final response = await dio.get<Map<String, dynamic>>('/shop/items');
      return listData(response.data)
          .map(
            (item) =>
                ShopItemDto.fromJson(Map<String, dynamic>.from(item as Map)),
          )
          .toList(growable: false);
    }),
    encode: (value) => value.map((item) => item.toJson()).toList(),
    decode: (value) => (value as List)
        .map(
          (item) =>
              ShopItemDto.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList(growable: false),
  );

  @override
  Future<PurchaseResultDto> purchase(
    PurchaseRequestDto request, {
    required String idempotencyKey,
  }) => guard(() async {
    final response = await retryIdempotent(
      () => dio.post<Map<String, dynamic>>(
        '/shop/purchase',
        data: request.toJson(),
        options: Options(
          headers: <String, Object>{'Idempotency-Key': idempotencyKey},
        ),
      ),
    );
    final result = PurchaseResultDto.fromJson(objectData(response.data));
    await Future.wait(<Future<void>>[
      invalidateCache('profile'),
      invalidateCache('shop:inventory'),
      invalidateCachePrefix('shop:ledger:'),
    ]);
    return result;
  });

  @override
  Future<List<InventoryItemDto>> getInventory() =>
      cachedRead<List<InventoryItemDto>>(
        key: 'shop:inventory',
        maxAge: const Duration(minutes: 2),
        fetch: () => guard(() async {
          final response = await dio.get<Map<String, dynamic>>('/me/inventory');
          return listData(response.data)
              .map((value) => Map<String, dynamic>.from(value as Map))
              .map(
                (item) => InventoryItemDto(
                  id: _string(item['itemCode']),
                  itemId: _string(item['itemCode']),
                  name: _string(item['name']),
                  description: '',
                  quantity: _int(item['ownedCount']),
                  equipped: item['equipped'] == true,
                ),
              )
              .toList(growable: false);
        }),
        encode: (value) => value.map((item) => item.toJson()).toList(),
        decode: (value) => (value as List)
            .map(
              (item) => InventoryItemDto.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList(growable: false),
      );

  @override
  Future<LedgerPageDto> getCoinLedger({String? cursor}) =>
      cachedRead<LedgerPageDto>(
        key: 'shop:ledger:${cursor ?? 'first'}',
        maxAge: const Duration(minutes: 1),
        fetch: () => guard(() async {
          final response = await dio.get<Map<String, dynamic>>(
            '/coins/ledger',
            queryParameters: <String, Object?>{'cursor': ?cursor},
          );
          final meta = response.data?['meta'];
          final nextCursor = (meta as Map?)?['nextCursor'];
          return LedgerPageDto(
            entries: listData(response.data)
                .map(
                  (item) => LedgerEntryDto.fromJson(
                    Map<String, dynamic>.from(item as Map),
                  ),
                )
                .toList(growable: false),
            nextCursor: nextCursor is String ? nextCursor : null,
          );
        }),
        encode: (value) => value.toJson(),
        decode: (value) =>
            LedgerPageDto.fromJson(Map<String, dynamic>.from(value as Map)),
      );
}

String _string(Object? value) => value is String ? value : '';

int _int(Object? value) => value is num ? value.toInt() : 0;
