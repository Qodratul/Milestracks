import 'package:flutter/material.dart';

@immutable
class MilestracksTokens extends ThemeExtension<MilestracksTokens> {
  const MilestracksTokens({
    required this.isDark,
    required this.voidColor,
    required this.slate,
    required this.mist,
    required this.sand,
    required this.umber,
    required this.primary,
    required this.secondary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.success,
    required this.warning,
    required this.error,
    required this.card,
    required this.hairline,
    required this.muted,
    required this.disabledBackground,
    required this.disabledForeground,
    required this.secondaryButtonBorder,
    required this.scrim,
    required this.skeleton,
    required this.skeletonHighlight,
    required this.shadow,
    required this.pageMaxWidth,
    required this.pagePadding,
    required this.buttonHeight,
    required this.textButtonHeight,
    required this.minimumTapTarget,
    required this.topBarHeight,
    required this.dockHeight,
    required this.modalGrabberWidth,
    required this.mascotWidth,
    required this.mascotHeight,
    required this.space2,
    required this.space4,
    required this.space6,
    required this.space8,
    required this.space10,
    required this.space12,
    required this.space14,
    required this.space16,
    required this.space18,
    required this.space20,
    required this.space22,
    required this.space24,
    required this.space28,
    required this.space32,
    required this.radiusSmall,
    required this.radiusMedium,
    required this.radiusCard,
    required this.radiusLarge,
    required this.radiusSheet,
    required this.radiusPill,
    required this.shadowBlur,
    required this.shadowOffsetY,
  });

  final bool isDark;
  final Color voidColor;
  final Color slate;
  final Color mist;
  final Color sand;
  final Color umber;
  final Color primary;
  final Color secondary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color success;
  final Color warning;
  final Color error;
  final Color card;
  final Color hairline;
  final Color muted;
  final Color disabledBackground;
  final Color disabledForeground;
  final Color secondaryButtonBorder;
  final Color scrim;
  final Color skeleton;
  final Color skeletonHighlight;
  final Color shadow;

  final double pageMaxWidth;
  final double pagePadding;
  final double buttonHeight;
  final double textButtonHeight;
  final double minimumTapTarget;
  final double topBarHeight;
  final double dockHeight;
  final double modalGrabberWidth;
  final double mascotWidth;
  final double mascotHeight;
  final double space2;
  final double space4;
  final double space6;
  final double space8;
  final double space10;
  final double space12;
  final double space14;
  final double space16;
  final double space18;
  final double space20;
  final double space22;
  final double space24;
  final double space28;
  final double space32;
  final double radiusSmall;
  final double radiusMedium;
  final double radiusCard;
  final double radiusLarge;
  final double radiusSheet;
  final double radiusPill;
  final double shadowBlur;
  final double shadowOffsetY;

  static const _void = Color(0xFF0A0908);
  static const _slate = Color(0xFF22333B);
  static const _mist = Color(0xFFF2F4F3);
  static const _sand = Color(0xFFA9927D);
  static const _umber = Color(0xFF5E503F);
  static const _primary = Color(0xFF203238);
  static const _secondary = Color(0xFFA9917B);
  static const _accent = Color(0xFFE8B85E);
  static const _surface = Color(0xFFFFFFFF);
  static const _textPrimary = Color(0xFF242824);
  static const _textSecondary = Color(0xFF5F6963);
  static const _textMuted = Color(0xFF737C76);
  static const _border = Color(0xFFDDDCD4);
  static const _success = Color(0xFF365D53);
  static const _error = Color(0xFF824C45);

  // Screen-specific colors extracted from the React page styles.
  static const homeBackgroundTop = Color(0xFFFBFCFA);
  static const homeBackgroundBottom = Color(0xFFF1F4F0);
  static const homeDeepGreen = Color(0xFF203A36);
  static const homeForestGreen = Color(0xFF34564C);
  static const homeMapBackground = Color(0xFFE3EBE4);
  static const homeRunDay = Color(0xFFC6DFC7);
  static const homeRunDayText = Color(0xFFF2F7ED);
  static const authBackgroundTop = Color(0xFFFBFCFA);
  static const authBackgroundBottom = Color(0xFFEEF2ED);
  static const authArtTop = Color(0xFFEDF2EC);
  static const authArtBottom = Color(0xFFDFE9E1);
  static const authCardTop = Color(0xFFF1E9DF);
  static const authCardBottom = Color(0xFFE9DFD2);
  static const authCardAccent = Color(0xFF9A7958);
  static const authFocus = Color(0xFF203238);
  static const notificationUnread = Color(0xFFF1F5F0);

  static MilestracksTokens get dark => MilestracksTokens(
    isDark: true,
    voidColor: _void,
    slate: _slate,
    mist: _mist,
    sand: _sand,
    umber: _umber,
    primary: _primary,
    secondary: _secondary,
    accent: _accent,
    background: _void,
    surface: Color.lerp(_slate, _void, .2)!,
    textPrimary: _mist,
    textSecondary: _mist.withValues(alpha: .78),
    textMuted: _mist.withValues(alpha: .62),
    border: _mist.withValues(alpha: .09),
    success: _success,
    warning: _accent,
    error: _error,
    card: Color.lerp(_slate, _void, .2)!,
    hairline: _mist.withValues(alpha: .09),
    muted: _mist.withValues(alpha: .62),
    disabledBackground: _umber.withValues(alpha: .4),
    disabledForeground: _mist.withValues(alpha: .4),
    secondaryButtonBorder: _mist.withValues(alpha: .38),
    scrim: _void.withValues(alpha: .74),
    skeleton: _slate,
    skeletonHighlight: _mist.withValues(alpha: .12),
    shadow: const Color(0x99000000),
    pageMaxWidth: 430,
    pagePadding: 20,
    buttonHeight: 56,
    textButtonHeight: 44,
    minimumTapTarget: 48,
    topBarHeight: 82,
    dockHeight: 68,
    modalGrabberWidth: 38,
    mascotWidth: 76,
    mascotHeight: 72,
    space2: 2,
    space4: 4,
    space6: 6,
    space8: 8,
    space10: 10,
    space12: 12,
    space14: 14,
    space16: 16,
    space18: 18,
    space20: 20,
    space22: 22,
    space24: 24,
    space28: 28,
    space32: 32,
    radiusSmall: 12,
    radiusMedium: 16,
    radiusCard: 24,
    radiusLarge: 28,
    radiusSheet: 32,
    radiusPill: 999,
    shadowBlur: 24,
    shadowOffsetY: 8,
  );

  static MilestracksTokens get light => MilestracksTokens(
    isDark: false,
    voidColor: _void,
    slate: _slate,
    mist: _mist,
    sand: _sand,
    umber: _umber,
    primary: _primary,
    secondary: _secondary,
    accent: _accent,
    background: const Color(0xFFF4F1EB),
    surface: _surface,
    textPrimary: _textPrimary,
    textSecondary: _textSecondary,
    textMuted: _textMuted,
    border: _border,
    success: _success,
    warning: _accent,
    error: _error,
    card: _surface,
    hairline: _slate.withValues(alpha: .14),
    muted: _textSecondary,
    disabledBackground: _umber.withValues(alpha: .4),
    disabledForeground: _mist.withValues(alpha: .4),
    secondaryButtonBorder: _slate.withValues(alpha: .38),
    scrim: _void.withValues(alpha: .74),
    skeleton: Color.lerp(_mist, _slate, .14)!,
    skeletonHighlight: _surface.withValues(alpha: .9),
    shadow: const Color(0x12213728),
    pageMaxWidth: 430,
    pagePadding: 20,
    buttonHeight: 56,
    textButtonHeight: 44,
    minimumTapTarget: 48,
    topBarHeight: 82,
    dockHeight: 68,
    modalGrabberWidth: 38,
    mascotWidth: 76,
    mascotHeight: 72,
    space2: 2,
    space4: 4,
    space6: 6,
    space8: 8,
    space10: 10,
    space12: 12,
    space14: 14,
    space16: 16,
    space18: 18,
    space20: 20,
    space22: 22,
    space24: 24,
    space28: 28,
    space32: 32,
    radiusSmall: 12,
    radiusMedium: 16,
    radiusCard: 24,
    radiusLarge: 28,
    radiusSheet: 32,
    radiusPill: 999,
    shadowBlur: 24,
    shadowOffsetY: 8,
  );

  @override
  MilestracksTokens copyWith({
    bool? isDark,
    Color? voidColor,
    Color? slate,
    Color? mist,
    Color? sand,
    Color? umber,
    Color? primary,
    Color? secondary,
    Color? accent,
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textMuted,
    Color? border,
    Color? success,
    Color? warning,
    Color? error,
    Color? card,
    Color? hairline,
    Color? muted,
    Color? disabledBackground,
    Color? disabledForeground,
    Color? secondaryButtonBorder,
    Color? scrim,
    Color? skeleton,
    Color? skeletonHighlight,
    Color? shadow,
    double? pageMaxWidth,
    double? pagePadding,
    double? buttonHeight,
    double? textButtonHeight,
    double? minimumTapTarget,
    double? topBarHeight,
    double? dockHeight,
    double? modalGrabberWidth,
    double? mascotWidth,
    double? mascotHeight,
    double? space2,
    double? space4,
    double? space6,
    double? space8,
    double? space10,
    double? space12,
    double? space14,
    double? space16,
    double? space18,
    double? space20,
    double? space22,
    double? space24,
    double? space28,
    double? space32,
    double? radiusSmall,
    double? radiusMedium,
    double? radiusCard,
    double? radiusLarge,
    double? radiusSheet,
    double? radiusPill,
    double? shadowBlur,
    double? shadowOffsetY,
  }) => MilestracksTokens(
    isDark: isDark ?? this.isDark,
    voidColor: voidColor ?? this.voidColor,
    slate: slate ?? this.slate,
    mist: mist ?? this.mist,
    sand: sand ?? this.sand,
    umber: umber ?? this.umber,
    primary: primary ?? this.primary,
    secondary: secondary ?? this.secondary,
    accent: accent ?? this.accent,
    background: background ?? this.background,
    surface: surface ?? this.surface,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textMuted: textMuted ?? this.textMuted,
    border: border ?? this.border,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    card: card ?? this.card,
    hairline: hairline ?? this.hairline,
    muted: muted ?? this.muted,
    disabledBackground: disabledBackground ?? this.disabledBackground,
    disabledForeground: disabledForeground ?? this.disabledForeground,
    secondaryButtonBorder: secondaryButtonBorder ?? this.secondaryButtonBorder,
    scrim: scrim ?? this.scrim,
    skeleton: skeleton ?? this.skeleton,
    skeletonHighlight: skeletonHighlight ?? this.skeletonHighlight,
    shadow: shadow ?? this.shadow,
    pageMaxWidth: pageMaxWidth ?? this.pageMaxWidth,
    pagePadding: pagePadding ?? this.pagePadding,
    buttonHeight: buttonHeight ?? this.buttonHeight,
    textButtonHeight: textButtonHeight ?? this.textButtonHeight,
    minimumTapTarget: minimumTapTarget ?? this.minimumTapTarget,
    topBarHeight: topBarHeight ?? this.topBarHeight,
    dockHeight: dockHeight ?? this.dockHeight,
    modalGrabberWidth: modalGrabberWidth ?? this.modalGrabberWidth,
    mascotWidth: mascotWidth ?? this.mascotWidth,
    mascotHeight: mascotHeight ?? this.mascotHeight,
    space2: space2 ?? this.space2,
    space4: space4 ?? this.space4,
    space6: space6 ?? this.space6,
    space8: space8 ?? this.space8,
    space10: space10 ?? this.space10,
    space12: space12 ?? this.space12,
    space14: space14 ?? this.space14,
    space16: space16 ?? this.space16,
    space18: space18 ?? this.space18,
    space20: space20 ?? this.space20,
    space22: space22 ?? this.space22,
    space24: space24 ?? this.space24,
    space28: space28 ?? this.space28,
    space32: space32 ?? this.space32,
    radiusSmall: radiusSmall ?? this.radiusSmall,
    radiusMedium: radiusMedium ?? this.radiusMedium,
    radiusCard: radiusCard ?? this.radiusCard,
    radiusLarge: radiusLarge ?? this.radiusLarge,
    radiusSheet: radiusSheet ?? this.radiusSheet,
    radiusPill: radiusPill ?? this.radiusPill,
    shadowBlur: shadowBlur ?? this.shadowBlur,
    shadowOffsetY: shadowOffsetY ?? this.shadowOffsetY,
  );

  @override
  MilestracksTokens lerp(ThemeExtension<MilestracksTokens>? other, double t) {
    if (other is! MilestracksTokens) return this;
    Color blend(Color a, Color b) => Color.lerp(a, b, t)!;
    return copyWith(
      isDark: t < .5 ? isDark : other.isDark,
      voidColor: blend(voidColor, other.voidColor),
      slate: blend(slate, other.slate),
      mist: blend(mist, other.mist),
      sand: blend(sand, other.sand),
      umber: blend(umber, other.umber),
      primary: blend(primary, other.primary),
      secondary: blend(secondary, other.secondary),
      accent: blend(accent, other.accent),
      background: blend(background, other.background),
      surface: blend(surface, other.surface),
      textPrimary: blend(textPrimary, other.textPrimary),
      textSecondary: blend(textSecondary, other.textSecondary),
      textMuted: blend(textMuted, other.textMuted),
      border: blend(border, other.border),
      success: blend(success, other.success),
      warning: blend(warning, other.warning),
      error: blend(error, other.error),
      card: blend(card, other.card),
      hairline: blend(hairline, other.hairline),
      muted: blend(muted, other.muted),
      disabledBackground: blend(disabledBackground, other.disabledBackground),
      disabledForeground: blend(disabledForeground, other.disabledForeground),
      secondaryButtonBorder: blend(
        secondaryButtonBorder,
        other.secondaryButtonBorder,
      ),
      scrim: blend(scrim, other.scrim),
      skeleton: blend(skeleton, other.skeleton),
      skeletonHighlight: blend(skeletonHighlight, other.skeletonHighlight),
      shadow: blend(shadow, other.shadow),
    );
  }
}
