import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/page_header.dart';
import '../../core/widgets/section_heading.dart';
import '../../services/url_service.dart';
import 'widgets/event_card.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingEventProvider);
    final past = ref.watch(pastEventsProvider);

    return Column(
      children: [
        const PageHeader(
          eyebrow: 'Events',
          title: 'Meetups, talks & workshops',
          subtitle:
              'We meet in Birmingham to learn from each other, share what '
              'we\'re building and talk all things Flutter and Dart.',
        ),
        PageSection(
          child: ContentContainer(
            child: upcoming != null
                ? FeaturedEventCard(event: upcoming)
                : const EmptyState(
                    icon: Icons.event_outlined,
                    title: 'The next meetup is being planned',
                    message:
                        'Join us on Meetup to hear first when it\'s announced.',
                  ),
          ),
        ),
        PageSection(
          color: AppColors.tint50,
          child: ContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeading(eyebrow: 'Archive', title: 'Past events'),
                const SizedBox(height: AppSpacing.xl),
                if (past.isEmpty)
                  const EmptyState(
                    icon: Icons.video_library_outlined,
                    title: 'Recordings will live here',
                    message:
                        'Slides and recordings from past meetups will '
                        'appear here after each event.',
                    showCta: false,
                  )
                else
                  ResponsiveGrid(
                    children: [for (final e in past) PastEventCard(event: e)],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.showCta = true,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool showCta;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.tint100,
            child: Icon(icon, size: 30, color: AppColors.sky),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (showCta) ...[
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              child: const Text('Join on Meetup'),
            ),
          ],
        ],
      ),
    );
  }
}
