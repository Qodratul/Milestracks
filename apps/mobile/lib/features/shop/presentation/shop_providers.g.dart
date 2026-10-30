// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shopCatalog)
final shopCatalogProvider = ShopCatalogProvider._();

final class ShopCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShopItemDto>>,
          List<ShopItemDto>,
          FutureOr<List<ShopItemDto>>
        >
    with
        $FutureModifier<List<ShopItemDto>>,
        $FutureProvider<List<ShopItemDto>> {
  ShopCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopCatalogHash();

  @$internal
  @override
  $FutureProviderElement<List<ShopItemDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ShopItemDto>> create(Ref ref) {
    return shopCatalog(ref);
  }
}

String _$shopCatalogHash() => r'b399c1f053b5feb9765cf9d1e3ea6e114075f033';

@ProviderFor(userInventory)
final userInventoryProvider = UserInventoryProvider._();

final class UserInventoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItemDto>>,
          List<InventoryItemDto>,
          FutureOr<List<InventoryItemDto>>
        >
    with
        $FutureModifier<List<InventoryItemDto>>,
        $FutureProvider<List<InventoryItemDto>> {
  UserInventoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userInventoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userInventoryHash();

  @$internal
  @override
  $FutureProviderElement<List<InventoryItemDto>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItemDto>> create(Ref ref) {
    return userInventory(ref);
  }
}

String _$userInventoryHash() => r'6e29033bc2ee0e2189876e778b70be221e68d3e0';

@ProviderFor(coinLedger)
final coinLedgerProvider = CoinLedgerProvider._();

final class CoinLedgerProvider
    extends
        $FunctionalProvider<
          AsyncValue<LedgerPageDto>,
          LedgerPageDto,
          FutureOr<LedgerPageDto>
        >
    with $FutureModifier<LedgerPageDto>, $FutureProvider<LedgerPageDto> {
  CoinLedgerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'coinLedgerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$coinLedgerHash();

  @$internal
  @override
  $FutureProviderElement<LedgerPageDto> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LedgerPageDto> create(Ref ref) {
    return coinLedger(ref);
  }
}

String _$coinLedgerHash() => r'40eb58215cc2032028710c69dba43e2cfa6d2318';

@ProviderFor(ShopPurchaseController)
final shopPurchaseControllerProvider = ShopPurchaseControllerProvider._();

final class ShopPurchaseControllerProvider
    extends $AsyncNotifierProvider<ShopPurchaseController, void> {
  ShopPurchaseControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shopPurchaseControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shopPurchaseControllerHash();

  @$internal
  @override
  ShopPurchaseController create() => ShopPurchaseController();
}

String _$shopPurchaseControllerHash() =>
    r'505e8c12fb228b0eb119e8a603a63eada64a7bd8';

abstract class _$ShopPurchaseController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
