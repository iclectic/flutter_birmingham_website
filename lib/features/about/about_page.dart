import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/section_heading.dart';
import '../../services/url_service.dart';
import '../../core/constants/app_strings.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                eyebrow: 'ABOUT',
                title: 'About Flutter Birmingham',
                subtitle:
                    'A community for Flutter and Dart developers in Birmingham and the Midlands.',
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
                vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
              ),
              child: isMobile ? _MobileContent() : _DesktopContent(),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _AboutText()),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(flex: 2, child: _AboutSidebar()),
      ],
    );
  }
}

class _MobileContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _AboutText(),
        const SizedBox(height: AppSpacing.xxl),
        _AboutSidebar(),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget heading(String text) => Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
          child: Text(text,
              style: theme.textTheme.titleLarge
                  ?.copyWith(color: AppColors.darkNavy, fontWeight: FontWeight.w700)),
        );

    Widget body(String text) =>
        Text(text, style: theme.textTheme.bodyLarge);

    return FadeInWidget(
      key: const Key('about-text'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading('What is Flutter Birmingham?'),
          body(
            'Flutter Birmingham is a free, independent community meetup for Flutter '
            'and Dart developers based in Birmingham, United Kingdom. We bring together '
            'developers, designers, students, and technology enthusiasts for regular events '
            'featuring talks, workshops, live demonstrations, and networking.',
          ),
          heading('Why was Flutter Birmingham established?'),
          body(
            'Flutter Birmingham was founded to create a dedicated space for Midlands '
            'developers to learn, share, and grow together. As Flutter rapidly expanded '
            'from a mobile framework to a truly cross-platform toolkit, it became clear '
            'that the Birmingham developer community deserved a regular gathering where '
            'practitioners could exchange real-world knowledge and experience.',
          ),
          heading('Who is Flutter Birmingham for?'),
          body(
            'Everyone is welcome. Whether you are writing your first Flutter app, '
            'building production apps for millions of users, or simply curious about '
            'what Flutter can do — there is a place for you at Flutter Birmingham. '
            'We deliberately design our programme to include content that is accessible '
            'to beginners as well as sessions that challenge experienced developers.',
          ),
          heading('What can you expect at a Flutter Birmingham event?'),
          body(
            'Our standard meetup runs for approximately two and a half hours and typically '
            'includes two main talks, a networking period, and refreshments. Talks range '
            'from technical deep-dives on Flutter internals to case studies, live coding '
            'demonstrations, and beginner introductions. We also host dedicated workshop '
            'evenings focused on building practical skills in a hands-on setting.',
          ),
          heading('Our commitment to inclusion'),
          body(
            'Flutter Birmingham is committed to creating and maintaining an environment '
            'that is welcoming, inclusive, and respectful. We operate under a published '
            'Code of Conduct that applies to all attendees, speakers, and organisers. '
            'We do not tolerate harassment, discrimination, or exclusionary behaviour of '
            'any kind. If you ever have a concern, we encourage you to contact us directly.',
          ),
          heading('How to get involved'),
          body(
            'There are many ways to contribute to Flutter Birmingham beyond attending events. '
            'You can propose a talk, volunteer at events, help with social media and content, '
            'offer your venue as a partner, or support the community as a sponsor. '
            'We are always looking for enthusiastic people who want to help build something '
            'genuinely valuable for Birmingham\'s technology community.',
          ),
          heading('Flutter Birmingham and the Flutter ecosystem'),
          body(
            'Flutter Birmingham is an independent community group and is not operated by or '
            'affiliated with Google LLC or the official Flutter team. We are part of a '
            'global network of community-run Flutter meetups, and we aim to represent '
            'Flutter\'s values of quality, openness, and accessibility in everything we do.',
          ),
          const SizedBox(height: AppSpacing.xl),
          Wrap(spacing: AppSpacing.md, runSpacing: AppSpacing.sm, children: [
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/events'),
              child: const Text('View Events'),
            ),
            OutlinedButton(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              child: const Text('Join on Meetup'),
            ),
          ]),
        ],
      ),
    );
  }
}

class _AboutSidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        FadeInWidget(
          key: const Key('about-sidebar-facts'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick facts',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Divider(height: AppSpacing.xl),
                _FactRow(icon: Icons.place_outlined, label: 'Location', value: 'Birmingham, UK'),
                _FactRow(icon: Icons.public_outlined, label: 'Language', value: 'English'),
                _FactRow(icon: Icons.money_off_outlined, label: 'Cost', value: 'Free to attend'),
                _FactRow(icon: Icons.event_outlined, label: 'Frequency', value: 'Monthly meetups'),
                _FactRow(icon: Icons.groups_outlined, label: 'Open to', value: 'Everyone'),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeInWidget(
          key: const Key('about-sidebar-links'),
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withAlpha(12),
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              border: Border.all(color: AppColors.flutterBlue.withAlpha(40)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get involved',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: AppSpacing.md),
                _ActionItem(
                    icon: Icons.mic_none_outlined,
                    text: 'Propose a talk',
                    onTap: () => UrlService.open(AppStrings.speakerFormUrl)),
                _ActionItem(
                    icon: Icons.volunteer_activism_outlined,
                    text: 'Volunteer at events',
                    onTap: () => GoRouter.of(context).go('/contact')),
                _ActionItem(
                    icon: Icons.handshake_outlined,
                    text: 'Become a sponsor',
                    onTap: () => UrlService.open(AppStrings.sponsorshipUrl)),
                _ActionItem(
                    icon: Icons.mail_outline_rounded,
                    text: 'Contact the team',
                    onTap: () => UrlService.openEmail(AppStrings.contactEmail)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FactRow extends StatelessWidget {
  const _FactRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.flutterBlue),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutralGrey, fontSize: 11)),
                Text(value,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.darkNavy,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem(
      {required this.icon, required this.text, required this.onTap});
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.flutterBlue, size: 20),
      title:
          Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 12, color: AppColors.neutralGrey),
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      dense: true,
    );
  }
}
