import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Flutter Birmingham logo: circular brand mark plus optional wordmark.
class FBLogo extends StatelessWidget {
  const FBLogo({
    super.key,
    this.height = 40,
    this.light = false,
    this.showWordmark = true,
  });

  static const String asset = 'assets/logos/flutter_birmingham_logo_256.webp';
  static const String largeAsset = 'assets/logos/flutter_birmingham_logo.webp';

  final double height;
  final bool light;
  final bool showWordmark;

  @override
  Widget build(BuildContext context) {
    final mark = Image.asset(
      height > 128 ? largeAsset : asset,
      width: height,
      height: height,
      filterQuality: FilterQuality.medium,
      semanticLabel: showWordmark ? null : 'Flutter Birmingham logo',
      errorBuilder: (context, error, stackTrace) =>
          Icon(Icons.flutter_dash, size: height, color: AppColors.sky),
    );
    if (!showWordmark) return mark;

    final fontSize = height * 0.46;
    return Semantics(
      label: 'Flutter Birmingham',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          mark,
          SizedBox(width: height * 0.28),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Flutter ',
                  style: TextStyle(
                    color: light ? AppColors.white : AppColors.body,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: 'Birmingham',
                  style: TextStyle(
                    color: light ? AppColors.white : AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            style: TextStyle(fontSize: fontSize, letterSpacing: -0.3),
          ),
        ],
      ),
    );
  }
}
