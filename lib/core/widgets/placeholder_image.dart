import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Renders a branded placeholder when an image asset is not yet available.
class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({
    super.key,
    this.width,
    this.height,
    this.label = 'Image placeholder',
    this.icon = Icons.image_outlined,
    this.borderRadius,
  });

  final double? width;
  final double? height;
  final String label;
  final IconData icon;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final widget = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: borderRadius,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFE8EDF2), Color(0xFFD0DBE8)],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.neutralGrey.withAlpha(120), size: 40),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.neutralGrey,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );

    return Semantics(label: label, child: widget);
  }
}

/// Tries to load an asset image; falls back to PlaceholderImage if the asset
/// does not exist (common during development before real photos are added).
class AssetImageOrPlaceholder extends StatelessWidget {
  const AssetImageOrPlaceholder({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderLabel = 'Image',
    this.borderRadius,
  });

  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String placeholderLabel;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stack) => PlaceholderImage(
          width: width,
          height: height,
          label: placeholderLabel,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
