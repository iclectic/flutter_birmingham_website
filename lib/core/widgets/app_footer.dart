import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../responsive/breakpoints.dart';
import '../responsive/responsive_layout.dart';
import '../../services/url_service.dart';
import 'fb_logo.dart';

class _FooterLink {
  const _FooterLink(this.label, {this.route, this.url});
  final String label;
  final String? route;
  final String? url;
}

const _columns = <String, List<_FooterLink>>{
  'Community': [
    _FooterLink('Meetup', url: AppStrings.meetupUrl),
    _FooterLink('LinkedIn', url: AppStrings.linkedInUrl),
    _FooterLink('YouTube', url: AppStrings.youTubeUrl),
    _FooterLink('Bluesky', url: AppStrings.blueskyUrl),
    _FooterLink('GitHub', url: AppStrings.gitHubUrl),
  ],
  'Get involved': [
    _FooterLink('Upcoming events', url: AppStrings.meetupUrl),
    _FooterLink('Give a talk', url: AppStrings.speakerFormUrl),
    _FooterLink('Meet the team', route: '/team'),
    _FooterLink('Code of Conduct', route: '/code-of-conduct'),
  ],
  'Developer resources': [
    _FooterLink('flutter.dev', url: 'https://flutter.dev'),
    _FooterLink('dart.dev', url: 'https://dart.dev'),
    _FooterLink('DartPad', url: 'https://dartpad.dev'),
    _FooterLink('pub.dev', url: 'https://pub.dev'),
  ],
};

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final theme = Theme.of(context);

    final brand = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FBLogo(height: 44),
        const SizedBox(height: AppSpacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 340),
          child: Text(AppStrings.tagline, style: theme.textTheme.bodyMedium),
        ),
        const SizedBox(height: AppSpacing.md),
        TextButton.icon(
          onPressed: () => UrlService.openEmail(AppStrings.contactEmail),
          icon: const Icon(Icons.mail_outline_rounded, size: 18),
          label: const Text(AppStrings.contactEmail),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
      ],
    );

    final columns = _columns.entries
        .map((e) => _FooterColumn(title: e.key, links: e.value))
        .toList();

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.surfaceGrey,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Breakpoints.isDesktop(context))
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 4, child: brand),
                    for (final c in columns) Expanded(flex: 2, child: c),
                  ],
                )
              else ...[
                brand,
                const SizedBox(height: AppSpacing.xl),
                Wrap(
                  spacing: AppSpacing.xxl,
                  runSpacing: AppSpacing.xl,
                  children: columns,
                ),
              ],
              const SizedBox(height: AppSpacing.xxl),
              const Divider(),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  const FlutterLogo(size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Built with Flutter · ${AppStrings.copyright}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.independentNotice,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.links});
  final String title;
  final List<_FooterLink> links;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            color: AppColors.ink,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        for (final link in links)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: InkWell(
              onTap: () => link.route != null
                  ? context.go(link.route!)
                  : UrlService.open(link.url!),
              child: Text(
                link.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.body,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
