import 'package:flutter/material.dart';
import 'package:milestracks/core/theme/milestracks_tokens.dart';

abstract final class MilestracksTheme {
  static const fontFamily = 'PlusJakartaSans';

  static ThemeData get light => _build(MilestracksTokens.light);
  static ThemeData get dark => _build(MilestracksTokens.dark);

  static ThemeData _build(MilestracksTokens tokens) {
    final brightness = tokens.isDark ? Brightness.dark : Brightness.light;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: tokens.primary,
      onPrimary: tokens.surface,
      secondary: tokens.secondary,
      onSecondary: tokens.textPrimary,
      error: tokens.error,
      onError: tokens.mist,
      surface: tokens.surface,
      onSurface: tokens.textPrimary,
      outline: tokens.border,
    );
    final fontWeight750 = FontWeight.lerp(
      FontWeight.w700,
      FontWeight.w800,
      .5,
    )!;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: tokens.background,
      canvasColor: tokens.background,
      dividerColor: tokens.hairline,
      iconTheme: IconThemeData(color: tokens.textPrimary),
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 38,
          height: 1.1,
          letterSpacing: -.045 * 38,
          fontWeight: fontWeight750,
        ),
        headlineLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 32,
          height: 1.15,
          letterSpacing: -.035 * 32,
          fontWeight: fontWeight750,
        ),
        headlineMedium: TextStyle(
          color: tokens.textPrimary,
          fontSize: 27,
          height: 1.15,
          letterSpacing: -.03 * 27,
          fontWeight: fontWeight750,
        ),
        headlineSmall: TextStyle(
          color: tokens.textPrimary,
          fontSize: 32,
          height: 1.08,
          letterSpacing: -.05 * 32,
          fontWeight: FontWeight.w700,
        ),
        titleLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 25,
          height: 1.15,
          letterSpacing: -.025 * 25,
          fontWeight: fontWeight750,
        ),
        displaySmall: TextStyle(
          color: tokens.textPrimary,
          fontSize: 42,
          height: 1.02,
          letterSpacing: -.065 * 42,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: TextStyle(
          color: tokens.textPrimary,
          fontSize: 17,
          height: 1.3,
          fontWeight: FontWeight.w700,
        ),
        bodyLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 16,
          height: 1.45,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: tokens.textPrimary,
          fontSize: 14,
          height: 1.45,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: TextStyle(
          color: tokens.textSecondary,
          fontSize: 13,
          height: 1.4,
          fontWeight: FontWeight.w400,
        ),
        labelLarge: TextStyle(
          color: tokens.textPrimary,
          fontSize: 13,
          height: 1.3,
          fontWeight: FontWeight.w700,
        ),
        labelMedium: TextStyle(
          color: tokens.textSecondary,
          fontSize: 12,
          height: 1.3,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: TextStyle(
          color: tokens.textMuted,
          fontSize: 11,
          height: 1.45,
          fontWeight: FontWeight.w700,
          letterSpacing: .12 * 11,
        ),
      ),
      extensions: <ThemeExtension<dynamic>>[tokens],
      appBarTheme: AppBarTheme(
        backgroundColor: tokens.background,
        foregroundColor: tokens.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: tokens.textPrimary,
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

extension MilestracksThemeContext on BuildContext {
  MilestracksTokens get milestracksTokens =>
      Theme.of(this).extension<MilestracksTokens>()!;
}
