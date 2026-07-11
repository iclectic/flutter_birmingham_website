import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/placeholder_image.dart';
import '../../core/widgets/section_heading.dart';
import '../../data/models/team_member.dart';
import '../../services/url_service.dart';

class TeamPage extends ConsumerWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organisersAsync = ref.watch(organisersProvider);
    final volunteersAsync = ref.watch(volunteersProvider);
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.darkNavy, AppColors.flutterBlue],
            ),
          ),
          child: ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl,
              ),
              child: const SectionHeading(
                eyebrow: 'TEAM',
                title: 'Meet the team',
                subtitle:
                    'Flutter Birmingham is run by a small team of volunteer organisers who are passionate about the Flutter community.',
                light: true,
              ),
            ),
          ),
        ),

        Container(
          color: AppColors.offWhite,
          child: ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organisers
                  const SectionHeading(
                    eyebrow: 'ORGANISERS',
                    title: 'Core team',
                    subtitle:
                        'The people who plan, coordinate, and run every Flutter Birmingham event.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  organisersAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Text('Unable to load team.'),
                    data: (organisers) => ResponsiveGrid(
                      mobileColumns: 1,
                      tabletColumns: 2,
                      desktopColumns: 3,
                      spacing: 24,
                      runSpacing: 24,
                      children: organisers
                          .asMap()
                          .entries
                          .map((e) => FadeInWidget(
                                key: Key('organiser-${e.key}'),
                                delay: Duration(milliseconds: e.key * 100),
                                child: TeamMemberCard(member: e.value),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Volunteers
                  const SectionHeading(
                    eyebrow: 'VOLUNTEERS',
                    title: 'Community volunteers',
                    subtitle:
                        'The people who give their time to help make our events great.',
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  volunteersAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Text('Unable to load volunteers.'),
                    data: (volunteers) => ResponsiveGrid(
                      mobileColumns: 1,
                      tabletColumns: 2,
                      desktopColumns: 3,
                      spacing: 24,
                      runSpacing: 24,
                      children: volunteers
                          .asMap()
                          .entries
                          .map((e) => FadeInWidget(
                                key: Key('volunteer-${e.key}'),
                                delay: Duration(milliseconds: e.key * 100),
                                child: TeamMemberCard(member: e.value),
                              ))
                          .toList(),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  // Contribute CTA
                  FadeInWidget(
                    key: const Key('team-cta'),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFEFF6FF), Color(0xFFE0F0FF)],
                        ),
                        borderRadius:
                            BorderRadius.circular(AppSpacing.cardRadius + 8),
                        border: Border.all(
                            color: AppColors.flutterBlue.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Want to get involved?',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: AppSpacing.sm),
                                Text(
                                  'We\'re always looking for enthusiastic volunteers to join the Flutter Birmingham team.',
                                  style:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: AppSpacing.xl),
                          ElevatedButton(
                            onPressed: () => UrlService.open(
                                'mailto:hello@flutterbirmingham.dev?subject=Volunteer'),
                            child: const Text('Get in touch'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TeamMemberCard extends StatefulWidget {
  const TeamMemberCard({super.key, required this.member});
  final TeamMember member;

  @override
  State<TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(
            color: _hovered
                ? AppColors.flutterBlue.withAlpha(60)
                : AppColors.cardBorder,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.flutterBlue.withAlpha(16),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  )
                ]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(48),
                child: AssetImageOrPlaceholder(
                  assetPath: widget.member.photoAsset,
                  width: 96,
                  height: 96,
                  placeholderLabel: widget.member.name,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.member.name,
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.flutterBlue.withAlpha(16),
                  borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
                ),
                child: Text(
                  widget.member.role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.flutterBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                widget.member.bio,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.member.linkedInUrl != null)
                    _SocialLink(
                      icon: Icons.business_outlined,
                      url: widget.member.linkedInUrl!,
                      tooltip: 'LinkedIn',
                    ),
                  if (widget.member.gitHubUrl != null)
                    _SocialLink(
                      icon: Icons.code_outlined,
                      url: widget.member.gitHubUrl!,
                      tooltip: 'GitHub',
                    ),
                  if (widget.member.twitterUrl != null)
                    _SocialLink(
                      icon: Icons.alternate_email_outlined,
                      url: widget.member.twitterUrl!,
                      tooltip: 'X / Twitter',
                    ),
                  if (widget.member.websiteUrl != null)
                    _SocialLink(
                      icon: Icons.public_outlined,
                      url: widget.member.websiteUrl!,
                      tooltip: 'Website',
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLink extends StatelessWidget {
  const _SocialLink(
      {required this.icon, required this.url, required this.tooltip});
  final IconData icon;
  final String url;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: tooltip,
      button: true,
      child: IconButton(
        icon: Icon(icon, size: 18),
        color: AppColors.neutralGrey,
        tooltip: tooltip,
        onPressed: () => UrlService.open(url),
      ),
    );
  }
}
