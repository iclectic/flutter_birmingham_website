import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

class SectionHeading extends StatelessWidget {
  const SectionHeading({
    super.key,
    required this.title,
    this.subtitle,
    this.eyebrow,
    this.alignment = CrossAxisAlignment.start,
    this.light = false,
  });

  final String title;
  final String? subtitle;
  final String? eyebrow;
  final CrossAxisAlignment alignment;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleColor = light ? AppColors.white : AppColors.darkNavy;
    final subtitleColor =
        light ? AppColors.white.withAlpha(180) : AppColors.neutralGrey;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withAlpha(light ? 60 : 20),
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            ),
            child: Text(
              eyebrow!,
              style: theme.textTheme.labelSmall?.copyWith(
                color: light ? AppColors.lightBlue : AppColors.flutterBlue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: titleColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppSpacing.maxTextWidth),
            child: Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(color: subtitleColor),
            ),
          ),
        ],
      ],
    );
  }
}
