import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/section_heading.dart';
import '../../data/models/team_member.dart';
import '../../services/url_service.dart';

class TeamPage extends ConsumerWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final team = ref.watch(teamProvider);

    return Column(
      children: [
        const PageHeader(
          eyebrow: 'Team',
          title: 'Meet the Flutter Birmingham team',
          subtitle:
              'Flutter Birmingham is run by volunteers who work with Flutter '
              'day to day. Come and say hello at the next meetup.',
        ),
        PageSection(
          child: ContentContainer(
            child: ResponsiveGrid(
              children: [
                for (final (i, member) in team.indexed)
                  FadeInWidget(
                    delay: Duration(milliseconds: i * 120),
                    child: TeamMemberCard(member: member),
                  ),
              ],
            ),
          ),
        ),
        PageSection(
          color: AppColors.tint50,
          child: ContentContainer(
            child: Column(
              children: [
                const SectionHeading(
                  alignment: CrossAxisAlignment.center,
                  title: 'Want to help run Flutter Birmingham?',
                  subtitle:
                      'We could always use an extra pair of hands, whether that\'s on '
                      'the night, finding speakers or tracking down a venue. Drop us '
                      'an email.',
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => UrlService.openEmail(
                    AppStrings.contactEmail,
                    subject: 'Helping with Flutter Birmingham',
                  ),
                  icon: const Icon(Icons.mail_outline_rounded, size: 18),
                  label: const Text('Get in touch'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  const TeamMemberCard({super.key, required this.member});
  final TeamMember member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholder = member.isPlaceholder;

    return Semantics(
      container: true,
      label: placeholder ? 'Co-organiser profile coming soon' : null,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: placeholder ? AppColors.tint50 : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: placeholder ? AppColors.tint300 : AppColors.border,
          ),
          boxShadow: placeholder
              ? null
              : [
                  BoxShadow(
                    color: AppColors.blue.withAlpha(16),
                    blurRadius: 32,
                    offset: const Offset(0, 12),
                  ),
                ],
        ),
        child: Column(
          children: [
            _Avatar(member: member),
            const SizedBox(height: AppSpacing.lg),
            Text(
              member.name,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: placeholder ? AppColors.muted : AppColors.ink,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: member.teamRole == TeamRole.organiser
                    ? AppColors.action
                    : AppColors.tint100,
                borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
              ),
              child: Text(
                member.role,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: member.teamRole == TeamRole.organiser
                      ? AppColors.white
                      : AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              member.bio,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            if (!placeholder) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (member.websiteUrl != null)
                    _SocialLink(
                      icon: const Icon(Icons.public_rounded, size: 20),
                      url: member.websiteUrl!,
                      tooltip: 'Website',
                    ),
                  if (member.gitHubUrl != null)
                    _SocialLink(
                      icon: const FaIcon(
                        FontAwesomeIcons.github,
                        size: 20,
                        color: _gitHubColor,
                      ),
                      url: member.gitHubUrl!,
                      tooltip: 'GitHub',
                    ),
                  if (member.linkedInUrl != null)
                    _SocialLink(
                      icon: const FaIcon(
                        FontAwesomeIcons.linkedin,
                        size: 20,
                        color: _linkedInColor,
                      ),
                      url: member.linkedInUrl!,
                      tooltip: 'LinkedIn',
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.member});
  final TeamMember member;

  static const double size = 160;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tint100, AppColors.tint300],
        ),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline_rounded, size: 64, color: AppColors.sky),
          SizedBox(height: 4),
          Text(
            'Photo coming soon',
            style: TextStyle(fontSize: 12, color: AppColors.blue),
          ),
        ],
      ),
    );

    final photo = member.photoAsset;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.brandGradient,
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
        ),
        child: ClipOval(
          child: photo == null
              ? fallback
              : Image.asset(
                  photo,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                  semanticLabel: 'Photo of ${member.name}',
                  errorBuilder: (_, _, _) => fallback,
                ),
        ),
      ),
    );
  }
}

const _gitHubColor = Color(0xFF181717);
const _linkedInColor = Color(0xFF0A66C2);

class _SocialLink extends StatelessWidget {
  const _SocialLink({
    required this.icon,
    required this.url,
    required this.tooltip,
  });
  final Widget icon;
  final String url;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      color: AppColors.body,
      tooltip: tooltip,
      onPressed: () => UrlService.open(url),
    );
  }
}
