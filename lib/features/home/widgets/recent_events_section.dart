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

class RecentEventsSection extends ConsumerWidget {
  const RecentEventsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(pastEventsProvider);
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
                key: const Key('recent-events-heading'),
                child: Row(
                  children: [
                    const Expanded(
                      child: SectionHeading(
                        eyebrow: 'PAST EVENTS',
                        title: 'Recent meetups',
                        subtitle: 'Catch up on what we\'ve covered.',
                      ),
                    ),
                    if (!isMobile)
                      OutlinedButton.icon(
                        onPressed: () => context.go('/events'),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('View All Events'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              eventsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) =>
                    const Text('Unable to load events.'),
                data: (events) {
                  final recent = events.take(3).toList();
                  if (recent.isEmpty) {
                    return const Text('No past events yet.');
                  }
                  return ResponsiveGrid(
                    mobileColumns: 1,
                    tabletColumns: 2,
                    desktopColumns: 3,
                    spacing: 24,
                    runSpacing: 24,
                    children: recent
                        .asMap()
                        .entries
                        .map((entry) => FadeInWidget(
                              key: Key('recent-event-${entry.key}'),
                              delay: Duration(milliseconds: entry.key * 100),
                              child: _EventCard(event: entry.value),
                            ))
                        .toList(),
                  );
                },
              ),
              if (isMobile) ...[
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/events'),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View All Events'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  const _EventCard({required this.event});
  final CommunityEvent event;

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy');

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.cardRadius),
                  ),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: AssetImageOrPlaceholder(
                      assetPath: widget.event.imageAsset,
                      placeholderLabel: widget.event.title,
                    ),
                  ),
                ),
                if (widget.event.hasRecording)
                  Positioned(
                    top: AppSpacing.sm,
                    right: AppSpacing.sm,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Recording',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dateFormat.format(widget.event.startDateTime),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.flutterBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.event.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (widget.event.speakers.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      widget.event.speakers
                          .map((s) => s.name)
                          .join(', '),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.neutralGrey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    widget.event.description,
                    style: theme.textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: widget.event.topics.take(3).map((t) => Chip(
                          label: Text(t, style: const TextStyle(fontSize: 11)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        )).toList(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => GoRouter.of(context)
                          .go('/events/${widget.event.id}'),
                      child: const Text('View Event'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
