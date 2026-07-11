import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/section_heading.dart';

class WhyJoinSection extends StatelessWidget {
  const WhyJoinSection({super.key});

  static const _benefits = [
    _Benefit(Icons.school_outlined, 'Learn from experienced speakers',
        'Gain practical insights from developers working on real Flutter and Dart projects.'),
    _Benefit(Icons.code_outlined, 'Discover practical techniques',
        'Pick up patterns, tools, and approaches you can apply in your own work immediately.'),
    _Benefit(Icons.group_outlined, 'Meet other developers',
        'Grow your professional network with Midlands-based and visiting Flutter engineers.'),
    _Benefit(Icons.lightbulb_outlined, 'Share projects and ideas',
        'Present your work, get feedback, and find collaborators for your next project.'),
    _Benefit(Icons.handshake_outlined, 'Find collaborators',
        'Connect with designers, developers, and founders looking to build together.'),
    _Benefit(Icons.mic_outlined, 'Improve your public speaking',
        'We support new speakers and offer a welcoming environment for your first talk.'),
    _Benefit(Icons.location_city_outlined, 'Be part of Birmingham tech',
        'Help shape the Midlands technology community and represent Flutter in the region.'),
    _Benefit(Icons.volunteer_activism_outlined, 'Give back to the community',
        'Volunteer, mentor, or sponsor to help Flutter Birmingham grow and improve.'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.darkNavy, Color(0xFF0A2540)],
        ),
      ),
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInWidget(
                key: const Key('why-join-heading'),
                child: const SectionHeading(
                  eyebrow: 'WHY ATTEND',
                  title: 'Why join Flutter Birmingham?',
                  subtitle:
                      'Whether you\'re just starting out or you\'ve been building with Flutter for years, there\'s something here for you.',
                  light: true,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ResponsiveGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 2,
                spacing: 16,
                runSpacing: 16,
                children: _benefits
                    .asMap()
                    .entries
                    .map(
                      (entry) => FadeInWidget(
                        key: Key('benefit-${entry.key}'),
                        delay: Duration(milliseconds: entry.key * 60),
                        child: _BenefitRow(benefit: entry.value),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Benefit {
  const _Benefit(this.icon, this.title, this.description);
  final IconData icon;
  final String title;
  final String description;
}

class _BenefitRow extends StatelessWidget {
  const _BenefitRow({required this.benefit});
  final _Benefit benefit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.flutterBlue.withAlpha(80),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(benefit.icon, color: AppColors.lightBlue, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                benefit.title,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                benefit.description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.white.withAlpha(160),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
