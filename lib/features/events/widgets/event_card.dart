import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../data/models/community_event.dart';
import '../../../services/url_service.dart';
import 'event_art.dart';

/// Large featured card for the next upcoming event.
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({super.key, required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Breakpoints.isMobile(context);
    final date = DateFormat('EEEE d MMMM yyyy').format(event.startDateTime);
    final time =
        '${DateFormat('HH:mm').format(event.startDateTime)} – ${DateFormat('HH:mm').format(event.endDateTime)}';

    final details = Padding(
      padding: EdgeInsets.all(isMobile ? AppSpacing.lg : AppSpacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.tint100,
              borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
            ),
            child: Text(
              'NEXT MEETUP',
              style: theme.textTheme.labelMedium?.copyWith(
                color: AppColors.blue,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            event.title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontSize: isMobile ? 24 : 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _InfoRow(icon: Icons.calendar_today_outlined, text: date),
          _InfoRow(icon: Icons.schedule_outlined, text: time),
          _InfoRow(
            icon: Icons.place_outlined,
            text: '${event.venueName} · ${event.venueAddress}',
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            event.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              FilledButton(
                onPressed: () => UrlService.open(event.registrationUrl),
                child: const Text('Reserve your spot'),
              ),
              OutlinedButton(
                onPressed: () => context.go('/events/${event.id}'),
                child: const Text('Event details'),
              ),
              TextButton.icon(
                onPressed: () => UrlService.addToGoogleCalendar(
                  title: event.title,
                  start: event.startDateTime,
                  end: event.endDateTime,
                  location: event.venueAddress,
                  description: event.description,
                ),
                icon: const Icon(Icons.event_available_outlined, size: 18),
                label: const Text('Add to calendar'),
              ),
            ],
          ),
        ],
      ),
    );

    final art = ClipRRect(
      borderRadius: isMobile
          ? const BorderRadius.vertical(top: Radius.circular(24))
          : const BorderRadius.horizontal(right: Radius.circular(24)),
      child: EventArt(event: event),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withAlpha(18),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(aspectRatio: 16 / 9, child: art),
                details,
              ],
            )
          : IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 3, child: details),
                  Expanded(flex: 2, child: art),
                ],
              ),
            ),
    );
  }
}

/// Compact card for past events.
class PastEventCard extends StatelessWidget {
  const PastEventCard({super.key, required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.go('/events/${event.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: EventArt(event: event),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat('d MMM yyyy').format(event.startDateTime),
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.sky,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(event.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (event.hasRecording) ...[
                    const SizedBox(height: AppSpacing.sm),
                    const Row(
                      children: [
                        Icon(
                          Icons.play_circle_outline,
                          size: 18,
                          color: AppColors.action,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Recording available',
                          style: TextStyle(color: AppColors.action),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.sky),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }
}
