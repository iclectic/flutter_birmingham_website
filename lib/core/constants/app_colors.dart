import 'package:flutter/material.dart';

/// Palette aligned with flutter.dev and the Flutter brand.
abstract final class AppColors {
  // Brand blues
  static const Color navy = Color(0xFF042B59);
  static const Color blue = Color(0xFF0553B1);
  static const Color sky = Color(0xFF027DFD);
  static const Color action = Color(0xFF1A68D3);
  static const Color aqua = Color(0xFF54C5F8);
  static const Color purple = Color(0xFF833EF2);

  // Light tints (flutter.dev surfaces)
  static const Color tint50 = Color(0xFFF3FCFF);
  static const Color tint100 = Color(0xFFE7F8FF);
  static const Color tint200 = Color(0xFFDCF5FF);
  static const Color tint300 = Color(0xFFB8EAFE);

  // Neutrals
  static const Color white = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF1F1F1F);
  static const Color body = Color(0xFF4A4A4A);
  static const Color muted = Color(0xFF6B7280);
  static const Color border = Color(0xFFDADCE0);
  static const Color surfaceGrey = Color(0xFFF8F9FA);

  static const Color errorRed = Color(0xFFD93025);

  // Semantic aliases used across the app
  static const Color flutterBlue = blue;
  static const Color brightBlue = sky;
  static const Color lightBlue = aqua;
  static const Color darkNavy = navy;
  static const Color offWhite = tint50;
  static const Color neutralGrey = body;
  static const Color lightGrey = surfaceGrey;
  static const Color cardBorder = border;

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [sky, blue],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, blue],
  );
}
