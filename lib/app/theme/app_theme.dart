import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

abstract final class AppTheme {
  static const String fontFamily = 'Google Sans';

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.sky,
      primary: AppColors.action,
      onPrimary: AppColors.white,
      secondary: AppColors.blue,
      tertiary: AppColors.purple,
      surface: AppColors.white,
      onSurface: AppColors.ink,
      error: AppColors.errorRed,
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: fontFamily,
    );
    final t = base.textTheme;

    const pill = StadiumBorder();
    const buttonPadding = EdgeInsets.symmetric(horizontal: 28, vertical: 18);
    const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 16,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.white,
      textTheme: t.copyWith(
        displayLarge: t.displayLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.5,
          height: 1.05,
        ),
        displayMedium: t.displayMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
          height: 1.1,
        ),
        displaySmall: t.displaySmall?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: t.headlineLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineMedium: t.headlineMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        headlineSmall: t.headlineSmall?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        titleLarge: t.titleLarge?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: t.titleMedium?.copyWith(
          color: AppColors.ink,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: t.bodyLarge?.copyWith(
          color: AppColors.body,
          fontSize: 17,
          height: 1.6,
        ),
        bodyMedium: t.bodyMedium?.copyWith(
          color: AppColors.body,
          fontSize: 15,
          height: 1.55,
        ),
        bodySmall: t.bodySmall?.copyWith(color: AppColors.muted),
        labelLarge: t.labelLarge?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: AppColors.ink),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.action,
          foregroundColor: AppColors.white,
          padding: buttonPadding,
          shape: pill,
          textStyle: buttonText,
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.action,
          foregroundColor: AppColors.white,
          padding: buttonPadding,
          shape: pill,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.action,
          side: const BorderSide(color: AppColors.border),
          padding: buttonPadding,
          shape: pill,
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.action,
          textStyle: buttonText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: const BorderSide(color: AppColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.tint100,
        labelStyle: const TextStyle(
          fontFamily: fontFamily,
          color: AppColors.blue,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      focusColor: AppColors.sky.withAlpha(40),
    );
  }
}
