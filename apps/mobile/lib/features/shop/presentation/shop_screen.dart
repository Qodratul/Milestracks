import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:milestracks/core/error/app_exception.dart';
import 'package:milestracks/core/theme/milestracks_theme.dart';
import 'package:milestracks/features/shop/presentation/shop_providers.dart';
import 'package:milestracks/features/track/presentation/track_providers.dart';
import 'package:milestracks/l10n/app_localizations.dart';
import 'package:milestracks/shared/models/api_models.dart';
import 'package:milestracks/shared/widgets/milestracks_bottom_navigation.dart';
import 'package:milestracks/shared/widgets/milestracks_icon.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key, this.showBottomNavigation = true});

  final bool showBottomNavigation;

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: context.milestracksTokens.background,
      bottomNavigationBar: showBottomNavigation
          ? const MilestracksBottomNavigation(
              selected: MainDestination.shop,
              homeStyle: true,
            )
          : null,
      body: const SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _ShopTitle(),
            _StoreHero(),
            _ShopTabs(),
            Expanded(
              child: TabBarView(
                children: <Widget>[_CatalogTab(), _InventoryTab()],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ShopTitle extends StatelessWidget {
  const _ShopTitle();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 17),
      child: Text(
        strings.shopTitle,
        style: const TextStyle(
          fontSize: 18,
          height: 1.2,
          fontWeight: FontWeight.w700,
          color: Color(0xff16231c),
        ),
      ),
    );
  }
}

class _StoreHero extends ConsumerWidget {
  const _StoreHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final user = ref.watch(currentUserProvider).value;
    final coins = user?.coins ?? 0;
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 17),
      padding: const EdgeInsets.all(17),
      constraints: const BoxConstraints(minHeight: 153),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: const Color(0xffe6ebe6)),
        gradient: const LinearGradient(
          colors: <Color>[Color(0xffffffff), Color(0xfff3f7f2)],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0b1d3727),
            blurRadius: 17,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: <Widget>[
          Positioned(
            right: -58,
            bottom: -133,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0x17456f4d)),
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        strings.shopStoreEyebrow,
                        style: const TextStyle(
                          color: Color(0xff718074),
                          fontSize: 8,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        strings.shopHeroTitle,
                        style: const TextStyle(
                          color: Color(0xff24392b),
                          fontSize: 21,
                          height: 1.07,
                          letterSpacing: -.8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        strings.shopHeroDescription,
                        style: const TextStyle(
                          color: Color(0xff738078),
                          fontSize: 9.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 123,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _BalanceCard(coins: coins, locale: locale),
                    const SizedBox(height: 7),
                    _TopUpButton(
                      onPressed: () => ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text(strings.shopTopUpUnavailable)),
                        ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({required this.coins, required this.locale});
  final int coins;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xeaffffff),
        border: Border.all(color: const Color(0xffe8ece8)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x091d3727),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xff315e40),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: _coloredCoin(Colors.white, 23)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  strings.shopBalanceEyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Color(0xff7a867d),
                    fontSize: 6.5,
                    letterSpacing: .35,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  NumberFormat.decimalPattern(locale).format(coins),
                  style: const TextStyle(
                    color: Color(0xff263b2d),
                    fontSize: 17,
                    height: 1.05,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  strings.shopCoinName,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    color: Color(0xff7c877e),
                    fontSize: 6.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopUpButton extends StatelessWidget {
  const _TopUpButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 34,
    child: FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add, size: 15),
      label: Text(
        AppLocalizations.of(context)!.shopTopUp,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xff315e40),
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
      ),
    ),
  );
}

class _ShopTabs extends StatelessWidget {
  const _ShopTabs();

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 14),
      padding: const EdgeInsets.all(4),
      height: 50,
      decoration: BoxDecoration(
        color: const Color(0xffedf1ed),
        border: Border.all(color: const Color(0xffe4e9e4)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TabBar(
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x1c1d3927),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        labelColor: const Color(0xff294632),
        unselectedLabelColor: const Color(0xff727e75),
        labelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        tabs: <Widget>[
          Tab(text: strings.shopCatalogTab),
          Tab(text: strings.shopInventoryTab),
        ],
      ),
    );
  }
}

class _CatalogTab extends ConsumerWidget {
  const _CatalogTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final catalog = ref.watch(shopCatalogProvider);
    final inventory =
        ref.watch(userInventoryProvider).value ?? const <InventoryItemDto>[];
    return catalog.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _RetryView(
        message: strings.shopPurchaseFailed,
        onRetry: () => ref.invalidate(shopCatalogProvider),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(shopCatalogProvider);
          ref.invalidate(userInventoryProvider);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 128),
          children: <Widget>[
            _SectionHeading(
              eyebrow: strings.shopCatalogEyebrow,
              title: strings.shopAvailableItems,
              count: strings.shopItemCount(items.length),
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  strings.shopEmpty,
                  style: const TextStyle(
                    color: Color(0xff748077),
                    fontSize: 12,
                  ),
                ),
              )
            else
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _ShopItemCard(
                    item: item,
                    inventory: inventory,
                    maxStock: item.maxStock,
                    busy: ref.watch(shopPurchaseControllerProvider).isLoading,
                    onBuy: () => unawaited(_buyItem(context, ref, item)),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.count,
  });
  final String eyebrow;
  final String title;
  final String count;

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              eyebrow,
              style: const TextStyle(
                fontSize: 7,
                letterSpacing: .65,
                fontWeight: FontWeight.w700,
                color: Color(0xff718074),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: Color(0xff24392b),
              ),
            ),
          ],
        ),
      ),
      Text(
        count,
        style: const TextStyle(fontSize: 8, color: Color(0xff738078)),
      ),
    ],
  );
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({
    required this.item,
    required this.inventory,
    required this.maxStock,
    required this.busy,
    required this.onBuy,
  });
  final ShopItemDto item;
  final List<InventoryItemDto> inventory;
  final int maxStock;
  final bool busy;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final strings = AppLocalizations.of(context)!;
    final owned = inventory
        .where((entry) => entry.itemId == item.id)
        .fold<int>(0, (sum, entry) => sum + entry.quantity);
    final popular = item.id == 'exp_boost';
    final risky = item.risky;
    final atLimit = maxStock > 0 && owned >= maxStock;
    return Container(
      constraints: const BoxConstraints(minHeight: 89),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffe7ebe7)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x071b3727),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          _ItemIcon(code: item.effectCode),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 5,
                  runSpacing: 2,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 11.5,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff293c30),
                      ),
                    ),
                    if (popular)
                      _ItemBadge(
                        label: strings.shopPopular,
                        background: const Color(0xfff5f0e4),
                        foreground: const Color(0xff8b7441),
                      ),
                    if (risky)
                      _ItemBadge(
                        label: strings.shopHigherRisk,
                        background: const Color(0xfff8eeeb),
                        foreground: const Color(0xffa35e4e),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8.5,
                    height: 1.35,
                    color: Color(0xff748077),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  strings.shopOwnedFraction(owned, maxStock),
                  style: const TextStyle(
                    fontSize: 7.5,
                    color: Color(0xff929a93),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          SizedBox(
            width: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 19,
                      height: 19,
                      decoration: const BoxDecoration(
                        color: Color(0xff315e40),
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: _coloredCoin(Colors.white, 13)),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      NumberFormat.decimalPattern(locale)
                          .format(item.priceCoins),
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff2d4234),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: 56,
                  height: 33,
                  child: FilledButton(
                    onPressed: item.available && !atLimit && !busy
                        ? onBuy
                        : null,
                    style: FilledButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: const Color(0xff315e40),
                      disabledBackgroundColor: const Color(0xffe9ede9),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      atLimit ? strings.shopMaxStock : strings.shopBuy,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemBadge extends StatelessWidget {
  const _ItemBadge({
    required this.label,
    required this.background,
    required this.foreground,
  });
  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(99),
    ),
    child: Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 5.5,
        height: 1,
        fontWeight: FontWeight.w800,
        letterSpacing: .25,
        color: foreground,
      ),
    ),
  );
}

class _ItemIcon extends StatelessWidget {
  const _ItemIcon({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) => Container(
    width: 42,
    height: 42,
    decoration: BoxDecoration(
      color: const Color(0xffedf3ed),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Center(
      child: Icon(_itemIcon(code), size: 20, color: const Color(0xff426d4b)),
    ),
  );
}

class _InventoryTab extends ConsumerWidget {
  const _InventoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final inventory = ref.watch(userInventoryProvider);
    final catalog =
        ref.watch(shopCatalogProvider).value ?? const <ShopItemDto>[];
    final stockByItemId = <String, int>{
      for (final product in catalog) product.id: product.maxStock,
    };
    return inventory.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, _) => _RetryView(
        message: strings.shopPurchaseFailed,
        onRetry: () => ref.invalidate(userInventoryProvider),
      ),
      data: (items) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(userInventoryProvider),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 128),
          children: <Widget>[
            _SectionHeading(
              eyebrow: strings.shopInventoryEyebrow,
              title: strings.shopInventoryTitle,
              count: strings.shopOwnedCountTotal(
                items.fold<int>(0, (sum, item) => sum + item.quantity),
              ),
            ),
            const SizedBox(height: 10),
            if (items.isEmpty)
              _InventoryEmpty(
                onShop: () => DefaultTabController.of(context).animateTo(0),
              )
            else
              for (final item in items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: _InventoryCard(
                    item: item,
                    maxStock: stockByItemId[item.itemId] ?? 0,
                    onAction: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text(
                              item.itemId == 'streak_freeze'
                                  ? strings.shopAutoUseNotice
                                  : strings.shopEquippedNotice,
                            ),
                          ),
                        );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({
    required this.item,
    required this.maxStock,
    required this.onAction,
  });
  final InventoryItemDto item;
  final int maxStock;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Container(
      constraints: const BoxConstraints(minHeight: 82),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xffe7ebe7)),
        borderRadius: BorderRadius.circular(17),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x071b3727),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          _ItemIcon(code: item.itemId),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: item.name,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff293c30),
                    ),
                    children: <InlineSpan>[
                      TextSpan(
                        text: maxStock > 0
                            ? '  ${strings.shopOwnedFraction(item.quantity, maxStock)}'
                            : '  ${item.quantity}',
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff8a958c),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  item.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 8,
                    height: 1.35,
                    color: Color(0xff748077),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 34,
            child: FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 11),
                backgroundColor: const Color(0xff315e40),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                item.itemId == 'streak_freeze'
                    ? strings.shopAutoUse
                    : item.equipped
                    ? strings.shopEquipped
                    : strings.shopEquip,
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InventoryEmpty extends StatelessWidget {
  const _InventoryEmpty({required this.onShop});
  final VoidCallback onShop;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.inventory_2_outlined,
            size: 36,
            color: Color(0xff748077),
          ),
          const SizedBox(height: 12),
          Text(
            strings.inventoryEmpty,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xff263a2d),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(onPressed: onShop, child: Text(strings.shopGoToShop)),
        ],
      ),
    );
  }
}

Future<void> _buyItem(
  BuildContext context,
  WidgetRef ref,
  ShopItemDto item,
) async {
  final result = await ref
      .read(shopPurchaseControllerProvider.notifier)
      .purchase(item.id);
  if (!context.mounted) return;
  final error = ref.read(shopPurchaseControllerProvider).error;
  if (result == null &&
      error is AppException &&
      error.message == 'insufficientCoins') {
    await _showInsufficientCoins(context);
    return;
  }
  final strings = AppLocalizations.of(context)!;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          result != null
              ? strings.shopPurchaseSuccess
              : strings.shopPurchaseFailed,
        ),
      ),
    );
}

Future<void> _showInsufficientCoins(BuildContext context) async {
  await showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: AppLocalizations.of(context)!.shopClose,
    barrierColor: const Color(0xb330302e),
    transitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, animation, secondaryAnimation) =>
        const SizedBox.shrink(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final strings = AppLocalizations.of(context)!;
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            clipBehavior: Clip.antiAlias,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 14, 21, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                        width: 38,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xffeef0ed),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: const Color(0xfffafcf9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: IconTheme(
                          data: IconThemeData(color: Color(0xff315e40)),
                          child: MilestracksIcon('coin', size: 23),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      strings.shopInsufficientTitle,
                      style: const TextStyle(
                        fontSize: 25,
                        height: 1.15,
                        letterSpacing: -.8,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff262c28),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      strings.shopInsufficientDescription,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                        color: Color(0xff606a64),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          context.go('/generating');
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xff20343a),
                          foregroundColor: Colors.white,
                          elevation: 5,
                          shadowColor: const Color(0x33303c40),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          strings.shopRunToEarn,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          strings.shopClose,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff606a64),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _RetryView extends StatelessWidget {
  const _RetryView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(message),
        TextButton(
          onPressed: onRetry,
          child: Text(AppLocalizations.of(context)!.historyRetry),
        ),
      ],
    ),
  );
}

IconData _itemIcon(String code) => switch (code) {
  'streak_freeze' || 'penalty_reduction' => Icons.shield_outlined,
  'exp_multiplier' => Icons.bolt_outlined,
  'high_risk_multiplier' => Icons.route_outlined,
  _ => Icons.redeem_outlined,
};

Widget _coloredCoin(Color color, double size) => IconTheme(
  data: IconThemeData(color: color),
  child: MilestracksIcon('coin', size: size),
);
