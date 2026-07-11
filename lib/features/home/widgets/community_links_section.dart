import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../services/url_service.dart';

class CommunityLinksSection extends StatelessWidget {
  const CommunityLinksSection({super.key});

  static const _links = [
    _CommunityLink(
      icon: Icons.people_alt_outlined,
      label: 'Meetup',
      description: 'RSVP to events and join our Meetup group',
      url: AppStrings.meetupUrl,
      color: Color(0xFFED1C40),
    ),
    _CommunityLink(
      icon: Icons.business_outlined,
      label: 'LinkedIn',
      description: 'Follow Flutter Birmingham on LinkedIn',
      url: AppStrings.linkedInUrl,
      color: Color(0xFF0A66C2),
    ),
    _CommunityLink(
      icon: Icons.play_circle_outline_rounded,
      label: 'YouTube',
      description: 'Watch recordings of our past talks',
      url: AppStrings.youTubeUrl,
      color: Color(0xFFFF0000),
    ),
    _CommunityLink(
      icon: Icons.code_outlined,
      label: 'GitHub',
      description: 'Explore community code and samples',
      url: AppStrings.gitHubUrl,
      color: Color(0xFF24292E),
    ),
    _CommunityLink(
      icon: Icons.email_outlined,
      label: 'Email',
      description: 'Get in touch with the organisers',
      url: 'mailto:${AppStrings.contactEmail}',
      color: AppColors.flutterBlue,
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
                key: const Key('community-links-heading'),
                child: const SectionHeading(
                  eyebrow: 'CONNECT',
                  title: 'Find us online',
                  subtitle:
                      'Stay connected with Flutter Birmingham between events.',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ResponsiveGrid(
                mobileColumns: 1,
                tabletColumns: 2,
                desktopColumns: 3,
                spacing: 16,
                runSpacing: 16,
                children: _links
                    .asMap()
                    .entries
                    .map((entry) => FadeInWidget(
                          key: Key('community-link-${entry.key}'),
                          delay: Duration(milliseconds: entry.key * 80),
                          child: _CommunityLinkCard(link: entry.value),
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

class _CommunityLink {
  const _CommunityLink({
    required this.icon,
    required this.label,
    required this.description,
    required this.url,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String description;
  final String url;
  final Color color;
}

class _CommunityLinkCard extends StatefulWidget {
  const _CommunityLinkCard({required this.link});
  final _CommunityLink link;

  @override
  State<_CommunityLinkCard> createState() => _CommunityLinkCardState();
}

class _CommunityLinkCardState extends State<_CommunityLinkCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Semantics(
        label: '${widget.link.label}: ${widget.link.description}',
        button: true,
        child: GestureDetector(
          onTap: () => UrlService.open(widget.link.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(
                color: _hovered
                    ? widget.link.color.withAlpha(80)
                    : AppColors.cardBorder,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.link.color.withAlpha(20),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: widget.link.color.withAlpha(16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    widget.link.icon,
                    color: widget.link.color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.link.label,
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: AppColors.darkNavy,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.link.description,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: _hovered
                      ? widget.link.color
                      : AppColors.neutralGrey.withAlpha(120),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
