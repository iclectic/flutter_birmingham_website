import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../responsive/breakpoints.dart';
import '../responsive/responsive_layout.dart';
import 'section_heading.dart';

/// Light, flutter.dev-style header band used at the top of inner pages.
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.subtitle,
  });

  final String title;
  final String? eyebrow;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.tint100, AppColors.white],
        ),
      ),
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl + 16,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: SectionHeading(
              eyebrow: eyebrow,
              title: title,
              subtitle: subtitle,
            ),
          ),
        ),
      ),
    );
  }
}
