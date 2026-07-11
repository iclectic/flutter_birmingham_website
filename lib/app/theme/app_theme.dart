import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';

abstract final class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.flutterBlue,
        primary: AppColors.flutterBlue,
        secondary: AppColors.lightBlue,
        surface: AppColors.white,
        onSurface: AppColors.darkNavy,
        brightness: Brightness.light,
      ),
    );

    final textTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme.copyWith(
        displayLarge: textTheme.displayLarge?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.5,
        ),
        displayMedium: textTheme.displayMedium?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
          letterSpacing: -1.0,
        ),
        displaySmall: textTheme.displaySmall?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        headlineLarge: textTheme.headlineLarge?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: textTheme.headlineMedium?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: textTheme.titleLarge?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: textTheme.titleMedium?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: textTheme.bodyLarge?.copyWith(
          color: AppColors.neutralGrey,
          height: 1.7,
        ),
        bodyMedium: textTheme.bodyMedium?.copyWith(
          color: AppColors.neutralGrey,
          height: 1.6,
        ),
        labelLarge: textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
      scaffoldBackgroundColor: AppColors.offWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        iconTheme: const IconThemeData(color: AppColors.darkNavy),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.flutterBlue,
          foregroundColor: AppColors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.flutterBlue,
          side: const BorderSide(color: AppColors.flutterBlue, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.flutterBlue,
          textStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.flutterBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          borderSide: const BorderSide(color: AppColors.errorRed),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.neutralGrey,
          fontSize: 15,
        ),
        labelStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.neutralGrey,
          fontSize: 15,
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.cardBorder,
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightGrey,
        labelStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.darkNavy,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
        ),
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
      ),
      focusColor: AppColors.lightBlue.withAlpha(40),
    );
  }
}
