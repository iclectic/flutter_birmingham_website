import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/placeholder_image.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../data/models/community_event.dart';
import '../../../services/url_service.dart';

class UpcomingEventSection extends ConsumerWidget {
  const UpcomingEventSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(upcomingEventProvider);
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      color: AppColors.white,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInWidget(
                key: const Key('upcoming-heading'),
                child: const SectionHeading(
                  eyebrow: 'NEXT EVENT',
                  title: 'Join us at our next meetup',
                  subtitle:
                      'All events are free to attend. Register on Meetup to secure your place.',
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              eventAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Text('Unable to load event details.'),
                data: (event) {
                  if (event == null) {
                    return _NoUpcomingEvent();
                  }
                  return FadeInWidget(
                    key: const Key('upcoming-card'),
                    child: _EventCard(event: event),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoUpcomingEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_outlined, size: 48, color: AppColors.neutralGrey),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No upcoming events scheduled yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Follow us on Meetup to be notified when the next event is announced.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => UrlService.open('https://www.meetup.com/flutter-birmingham/'),
            child: const Text('Follow on Meetup'),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkNavy.withAlpha(12),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventImage(event: event),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: _EventDetails(event: event),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: _EventDetails(event: event),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: _EventImage(event: event, roundLeft: false),
                ),
              ],
            ),
    );
  }
}

class _EventImage extends StatelessWidget {
  const _EventImage({required this.event, this.roundLeft = true});
  final CommunityEvent event;
  final bool roundLeft;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(AppSpacing.cardRadius),
        topRight: isMobile
            ? const Radius.circular(AppSpacing.cardRadius)
            : const Radius.circular(AppSpacing.cardRadius),
        bottomRight: isMobile
            ? Radius.zero
            : const Radius.circular(AppSpacing.cardRadius),
        bottomLeft: roundLeft ? Radius.zero : Radius.zero,
      ),
      child: AspectRatio(
        aspectRatio: isMobile ? 16 / 9 : 4 / 3,
        child: AssetImageOrPlaceholder(
          assetPath: event.imageAsset,
          placeholderLabel: 'Event photo for ${event.title}',
        ),
      ),
    );
  }
}

class _EventDetails extends StatelessWidget {
  const _EventDetails({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE d MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date chip
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.flutterBlue.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          ),
          child: Text(
            dateFormat.format(event.startDateTime),
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.flutterBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          event.title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        _InfoRow(
          icon: Icons.access_time_outlined,
          text:
              '${timeFormat.format(event.startDateTime)} – ${timeFormat.format(event.endDateTime)}',
        ),
        const SizedBox(height: AppSpacing.xs),
        _InfoRow(
          icon: Icons.location_on_outlined,
          text: '${event.venueName}, ${event.venueAddress}',
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          event.description,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        if (event.speakers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Featured Talks',
            style: theme.textTheme.labelLarge?.copyWith(color: AppColors.darkNavy),
          ),
          const SizedBox(height: AppSpacing.sm),
          ...event.speakers.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.lightGrey,
                      ),
                      child: const Icon(Icons.person_outline,
                          size: 18, color: AppColors.neutralGrey),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.talkTitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.darkNavy,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${s.name} · ${s.company}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.neutralGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ElevatedButton.icon(
              onPressed: () => UrlService.open(event.registrationUrl),
              icon: const Icon(Icons.confirmation_num_outlined, size: 18),
              label: const Text('Reserve Your Place'),
            ),
            OutlinedButton.icon(
              onPressed: () =>
                  GoRouter.of(context).go('/events/${event.id}'),
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('View Event Details'),
            ),
            OutlinedButton.icon(
              onPressed: () => UrlService.addToGoogleCalendar(
                title: event.title,
                start: event.startDateTime,
                end: event.endDateTime,
                location: event.venueAddress,
                description: event.description,
              ),
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: const Text('Add to Calendar'),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.neutralGrey),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.neutralGrey),
          ),
        ),
      ],
    );
  }
}
