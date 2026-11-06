import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../responsive/breakpoints.dart';

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
    final isMobile = Breakpoints.isMobile(context);
    final centered = alignment == CrossAxisAlignment.center;
    final textAlign = centered ? TextAlign.center : TextAlign.start;

    return Column(
      crossAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (eyebrow != null) ...[
          Text(
            eyebrow!.toUpperCase(),
            textAlign: textAlign,
            style: theme.textTheme.labelLarge?.copyWith(
              color: light ? AppColors.aqua : AppColors.sky,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.6,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Text(
          title,
          textAlign: textAlign,
          style: theme.textTheme.displaySmall?.copyWith(
            color: light ? AppColors.white : AppColors.ink,
            fontSize: isMobile ? 30 : 40,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.md),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSpacing.maxTextWidth,
            ),
            child: Text(
              subtitle!,
              textAlign: textAlign,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: light ? AppColors.white.withAlpha(210) : AppColors.body,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

/// Standard vertical rhythm wrapper for page sections.
class PageSection extends StatelessWidget {
  const PageSection({
    super.key,
    required this.child,
    this.color,
    this.gradient,
  });

  final Widget child;
  final Color? color;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: color, gradient: gradient),
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
      ),
      child: child,
    );
  }
}
