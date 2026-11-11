import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/fb_logo.dart';
import '../../core/widgets/section_heading.dart';
import '../../services/url_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Hero(),
        _Events(),
        _WhatWeDo(),
        _GetInvolved(),
        _Resources(),
        _JoinBanner(),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDesktop = Breakpoints.isDesktop(context);
    final isMobile = Breakpoints.isMobile(context);

    final headline = Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Build beautiful apps.\n'),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.sky, AppColors.purple],
              ).createShader(bounds),
              child: Text(
                'Together, in Birmingham.',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: AppColors.white,
                  fontSize: isMobile ? 40 : 64,
                ),
              ),
            ),
          ),
        ],
      ),
      textAlign: isDesktop ? TextAlign.start : TextAlign.center,
      style: theme.textTheme.displayLarge?.copyWith(
        fontSize: isMobile ? 40 : 64,
      ),
    );

    final copy = Column(
      crossAxisAlignment: isDesktop
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            border: Border.all(color: AppColors.tint300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const FlutterLogo(size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Flutter & Dart meetup · West Midlands',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.blue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        headline,
        const SizedBox(height: AppSpacing.lg),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            AppStrings.description,
            textAlign: isDesktop ? TextAlign.start : TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(fontSize: 19),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            FilledButton.icon(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              icon: const Icon(Icons.group_add_outlined, size: 20),
              label: const Text('Join on Meetup'),
            ),
            OutlinedButton(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              child: const Text('See upcoming events'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.md,
          alignment: isDesktop ? WrapAlignment.start : WrapAlignment.center,
          children: [
            for (final tag in AppStrings.hashtags)
              Text(
                tag,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: AppColors.muted,
                ),
              ),
          ],
        ),
      ],
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.tint100, AppColors.tint50, AppColors.white],
        ),
      ),
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.xxl : AppSpacing.section + 16,
          ),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(flex: 6, child: copy),
                    const SizedBox(width: AppSpacing.xxl),
                    const Expanded(flex: 4, child: _HeroArt(size: 400)),
                  ],
                )
              : Column(
                  children: [
                    _HeroArt(size: isMobile ? 200 : 280),
                    const SizedBox(height: AppSpacing.xl),
                    copy,
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroArt extends StatelessWidget {
  const _HeroArt({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return FadeInWidget(
      child: SizedBox.square(
        dimension: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.aqua.withAlpha(90),
                    AppColors.tint100.withAlpha(0),
                  ],
                ),
              ),
            ),
            Container(
              width: size * 0.82,
              height: size * 0.82,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.18),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withAlpha(60),
                    blurRadius: 60,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(size * 0.18),
                child: FBLogo(height: size * 0.82, showWordmark: false),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Events extends StatelessWidget {
  const _Events();

  @override
  Widget build(BuildContext context) {
    return PageSection(
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              eyebrow: 'Events',
              title: 'Join us at the next meetup',
              subtitle:
                  'Every meetup is announced on Meetup. RSVP there for the '
                  'date, venue and speakers, and to save your spot.',
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              icon: const Icon(Icons.event_outlined, size: 20),
              label: const Text('See upcoming events on Meetup'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Feature {
  const _Feature(this.icon, this.title, this.body, this.color);
  final IconData icon;
  final String title;
  final String body;
  final Color color;
}

const _features = [
  _Feature(
    Icons.mic_none_rounded,
    'Talks',
    'Deep dives and lightning talks from local and visiting Flutter '
        'developers — architecture, performance, design, Dart and more.',
    AppColors.sky,
  ),
  _Feature(
    Icons.code_rounded,
    'Workshops',
    'Hands-on sessions where you bring a laptop and build something real, '
        'from your first widget to advanced state management.',
    AppColors.purple,
  ),
  _Feature(
    Icons.forum_outlined,
    'Networking',
    'Meet the people building with Flutter across the West Midlands. '
        'Swap ideas, find collaborators and maybe your next role.',
    AppColors.blue,
  ),
];

class _WhatWeDo extends StatelessWidget {
  const _WhatWeDo();

  @override
  Widget build(BuildContext context) {
    return PageSection(
      color: AppColors.tint50,
      child: ContentContainer(
        child: Column(
          children: [
            const SectionHeading(
              alignment: CrossAxisAlignment.center,
              eyebrow: 'What we do',
              title: 'Learn, build and share',
              subtitle:
                  'Every meetup is free, friendly and open to all '
                  'experience levels.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            ResponsiveGrid(
              children: [
                for (final (i, f) in _features.indexed)
                  FadeInWidget(
                    delay: Duration(milliseconds: i * 120),
                    child: _FeatureCard(feature: f),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});
  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: feature.color.withAlpha(24),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(feature.icon, color: feature.color, size: 28),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(feature.title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(feature.body, style: theme.textTheme.bodyLarge),
        ],
      ),
    );
  }
}

class _GetInvolved extends StatelessWidget {
  const _GetInvolved();

  @override
  Widget build(BuildContext context) {
    final items = [
      (
        Icons.record_voice_over_outlined,
        'Give a talk',
        'First-time speakers are very welcome. We\'ll help you shape your idea '
            'into a great talk.',
        'Submit a talk',
        () => UrlService.open(AppStrings.speakerFormUrl),
      ),
      (
        Icons.apartment_outlined,
        'Host a meetup',
        'Have space for 40–80 developers in Birmingham? Put your company in '
            'front of the local Flutter community.',
        'Offer a venue',
        () => UrlService.openEmail(
          AppStrings.contactEmail,
          subject: 'Hosting Flutter Birmingham',
        ),
      ),
      (
        Icons.volunteer_activism_outlined,
        'Sponsor',
        'Food, drinks and swag keep our events free. Sponsors get a shout-out '
            'at every meetup.',
        'Become a sponsor',
        () => UrlService.openEmail(
          AppStrings.contactEmail,
          subject: 'Sponsoring Flutter Birmingham',
        ),
      ),
    ];

    return PageSection(
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              eyebrow: 'Get involved',
              title: 'This community is built by you',
              subtitle:
                  'Speak, host or sponsor and help Flutter grow in '
                  'Birmingham.',
            ),
            const SizedBox(height: AppSpacing.xxl),
            ResponsiveGrid(
              children: [
                for (final (icon, title, body, cta, onTap) in items)
                  _InvolveCard(
                    icon: icon,
                    title: title,
                    body: body,
                    cta: cta,
                    onTap: onTap,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
            Center(
              child: TextButton.icon(
                onPressed: () => context.go('/team'),
                icon: const Text('Meet the organisers'),
                label: const Icon(Icons.arrow_forward_rounded, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InvolveCard extends StatelessWidget {
  const _InvolveCard({
    required this.icon,
    required this.title,
    required this.body,
    required this.cta,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String body;
  final String cta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 280),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tint100, AppColors.tint50],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: AppColors.action),
          const SizedBox(height: AppSpacing.lg),
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.sm),
          Text(body, style: theme.textTheme.bodyLarge),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton(onPressed: onTap, child: Text(cta)),
        ],
      ),
    );
  }
}

class _Resources extends StatelessWidget {
  const _Resources();

  static const _links = [
    (
      'flutter.dev',
      'Docs, codelabs and the Flutter showcase.',
      'https://flutter.dev',
    ),
    ('dart.dev', 'The language behind Flutter.', 'https://dart.dev'),
    (
      'DartPad',
      'Write and run Flutter in your browser.',
      'https://dartpad.dev',
    ),
    ('pub.dev', 'Packages for Flutter and Dart.', 'https://pub.dev'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageSection(
      color: AppColors.tint50,
      child: ContentContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(
              eyebrow: 'New to Flutter?',
              title: 'Start building today',
              subtitle:
                  'Flutter is Google\'s open source framework for '
                  'building beautiful, natively compiled apps for mobile, web, '
                  'desktop and embedded from a single codebase.',
            ),
            const SizedBox(height: AppSpacing.xl),
            ResponsiveGrid(
              desktopColumns: 4,
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final (title, body, url) in _links)
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => UrlService.open(url),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    title,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      color: AppColors.action,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.north_east_rounded,
                                  size: 18,
                                  color: AppColors.action,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(body, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _JoinBanner extends StatelessWidget {
  const _JoinBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Breakpoints.isMobile(context);
    return PageSection(
      child: ContentContainer(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? AppSpacing.xl : AppSpacing.xxxl),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.blue, AppColors.sky],
            ),
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: [
              Text(
                'Join the Flutter Birmingham community',
                textAlign: TextAlign.center,
                style: theme.textTheme.displaySmall?.copyWith(
                  color: AppColors.white,
                  fontSize: isMobile ? 28 : 40,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Get notified about new meetups, talks and workshops.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.white.withAlpha(220),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: () => UrlService.open(AppStrings.meetupUrl),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.blue,
                ),
                child: const Text('Join on Meetup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
