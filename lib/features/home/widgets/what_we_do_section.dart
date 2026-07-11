import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/section_heading.dart';

class WhatWeDoSection extends StatelessWidget {
  const WhatWeDoSection({super.key});

  static const _features = [
    _Feature(
      icon: Icons.lightbulb_outline_rounded,
      title: 'Technical Talks',
      description:
          'Learn about Flutter, Dart, mobile development, architecture, testing, '
          'accessibility, AI, developer tools, and the latest in the ecosystem '
          'from speakers with real-world experience.',
    ),
    _Feature(
      icon: Icons.build_outlined,
      title: 'Practical Workshops',
      description:
          'Participate in guided hands-on sessions where you can develop practical '
          'Flutter and Dart skills with support from the community.',
    ),
    _Feature(
      icon: Icons.people_outline_rounded,
      title: 'Community Networking',
      description:
          'Meet developers, designers, founders, students, speakers, recruiters, '
          'and technology enthusiasts from Birmingham and the surrounding Midlands.',
    ),
    _Feature(
      icon: Icons.diversity_3_outlined,
      title: 'Open Community',
      description:
          'Everyone is welcome, regardless of experience level or background. '
          'We are committed to creating an inclusive, respectful, and '
          'encouraging environment for all.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      color: AppColors.offWhite,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInWidget(
                key: const Key('what-we-do-heading'),
                child: SectionHeading(
                  eyebrow: 'WHAT WE DO',
                  title: 'More than just a meetup',
                  subtitle:
                      'Flutter Birmingham brings together the Midlands developer '
                      'community through events that combine learning, building, and connecting.',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ResponsiveGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 2,
                spacing: 24,
                runSpacing: 24,
                children: _features
                    .asMap()
                    .entries
                    .map((entry) => FadeInWidget(
                          key: Key('feature-${entry.key}'),
                          delay: Duration(milliseconds: entry.key * 100),
                          child: _FeatureCard(feature: entry.value),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({required this.feature});
  final _Feature feature;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: _hovered ? AppColors.flutterBlue.withAlpha(80) : AppColors.cardBorder,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.flutterBlue.withAlpha(20),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ]
              : [
                  BoxShadow(
                    color: AppColors.darkNavy.withAlpha(8),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.flutterBlue.withAlpha(16),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                widget.feature.icon,
                color: AppColors.flutterBlue,
                size: 24,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feature.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppColors.darkNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.feature.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
