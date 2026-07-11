import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/placeholder_image.dart';
import '../../core/widgets/section_heading.dart';
import '../../data/models/community_event.dart';
import '../../services/url_service.dart';

class EventsPage extends ConsumerWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcomingAsync = ref.watch(upcomingEventProvider);
    final filteredAsync = ref.watch(filteredPastEventsProvider);
    final filter = ref.watch(eventsFilterProvider);
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      children: [
        // Page header
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl,
            horizontal: 0,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.darkNavy, AppColors.flutterBlue],
            ),
          ),
          child: ContentContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeInWidget(
                  key: const Key('events-heading'),
                  child: const SectionHeading(
                    eyebrow: 'EVENTS',
                    title: 'Flutter Birmingham Events',
                    subtitle:
                        'Talks, workshops, and community nights for Flutter and Dart developers in the Midlands.',
                    light: true,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Upcoming event
        upcomingAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (err, stack) => const SizedBox.shrink(),
          data: (event) {
            if (event == null) return const SizedBox.shrink();
            return Container(
              color: AppColors.white,
              child: ContentContainer(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical:
                        isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeading(
                        eyebrow: 'UPCOMING',
                        title: 'Next meetup',
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      _UpcomingEventBanner(event: event),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        // Filter bar + past events
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
                  const SectionHeading(
                    eyebrow: 'ARCHIVE',
                    title: 'Past events',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  _FilterBar(filter: filter, ref: ref),
                  const SizedBox(height: AppSpacing.xl),
                  filteredAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) =>
                        const Text('Unable to load past events.'),
                    data: (events) {
                      if (events.isEmpty) {
                        return _EmptyState(
                          hasFilters: filter.searchQuery.isNotEmpty ||
                              filter.selectedYear != null ||
                              filter.selectedTopic != null,
                          onClear: () =>
                              ref.read(eventsFilterProvider.notifier).clearFilters(),
                        );
                      }
                      return ResponsiveGrid(
                        mobileColumns: 1,
                        tabletColumns: 2,
                        desktopColumns: 3,
                        spacing: 24,
                        runSpacing: 24,
                        children: events
                            .map((e) => _PastEventCard(event: e))
                            .toList(),
                      );
                    },
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

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.filter, required this.ref});
  final EventsFilterState filter;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(eventsFilterProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search events, speakers, topics…',
              prefixIcon: const Icon(Icons.search_rounded,
                  color: AppColors.neutralGrey),
              filled: true,
              fillColor: AppColors.white,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              suffixIcon: filter.searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded),
                      onPressed: () => notifier.setSearch(''),
                    )
                  : null,
            ),
            onChanged: notifier.setSearch,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            _FilterChip(
              label: filter.selectedYear?.toString() ?? 'Year',
              isActive: filter.selectedYear != null,
              onTap: () => _showYearPicker(context, ref),
            ),
            _FilterChip(
              label: filter.selectedTopic ?? 'Topic',
              isActive: filter.selectedTopic != null,
              onTap: () => _showTopicPicker(context, ref),
            ),
            if (filter.searchQuery.isNotEmpty ||
                filter.selectedYear != null ||
                filter.selectedTopic != null)
              ActionChip(
                label: const Text('Clear filters'),
                avatar: const Icon(Icons.clear_rounded, size: 16),
                onPressed: notifier.clearFilters,
                backgroundColor: AppColors.lightGrey,
              ),
          ],
        ),
      ],
    );
  }

  void _showYearPicker(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => _YearPickerDialog(ref: ref),
    );
  }

  void _showTopicPicker(BuildContext context, WidgetRef ref) {
    showDialog<void>(
      context: context,
      builder: (_) => _TopicPickerDialog(ref: ref),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.flutterBlue.withAlpha(30),
      checkmarkColor: AppColors.flutterBlue,
      labelStyle: TextStyle(
        color: isActive ? AppColors.flutterBlue : AppColors.darkNavy,
        fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
        fontSize: 13,
      ),
      side: BorderSide(
        color: isActive ? AppColors.flutterBlue : AppColors.cardBorder,
      ),
      backgroundColor: AppColors.white,
    );
  }
}

class _YearPickerDialog extends ConsumerWidget {
  const _YearPickerDialog({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef watchRef) {
    final years = [2026, 2025, 2024, 2023];
    final selected = watchRef.watch(eventsFilterProvider).selectedYear;
    return AlertDialog(
      title: const Text('Filter by year'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('All years'),
            selected: selected == null,
            onTap: () {
              ref.read(eventsFilterProvider.notifier).setYear(null);
              Navigator.pop(context);
            },
          ),
          ...years.map((y) => ListTile(
                title: Text(y.toString()),
                selected: selected == y,
                onTap: () {
                  ref.read(eventsFilterProvider.notifier).setYear(y);
                  Navigator.pop(context);
                },
              )),
        ],
      ),
    );
  }
}

class _TopicPickerDialog extends ConsumerWidget {
  const _TopicPickerDialog({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef watchRef) {
    final topics = [
      'Flutter',
      'Dart',
      'State Management',
      'Testing',
      'Accessibility',
      'Architecture',
      'AI',
      'Performance',
      'Flutter Web',
    ];
    final selected = watchRef.watch(eventsFilterProvider).selectedTopic;
    return AlertDialog(
      title: const Text('Filter by topic'),
      content: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('All topics'),
              selected: selected == null,
              onTap: () {
                ref.read(eventsFilterProvider.notifier).setTopic(null);
                Navigator.pop(context);
              },
            ),
            ...topics.map((t) => ListTile(
                  title: Text(t),
                  selected: selected == t,
                  onTap: () {
                    ref.read(eventsFilterProvider.notifier).setTopic(t);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.hasFilters, required this.onClear});
  final bool hasFilters;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy_outlined,
              size: 48, color: AppColors.neutralGrey),
          const SizedBox(height: AppSpacing.md),
          Text(
            hasFilters
                ? 'No events match your filters'
                : 'No past events yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (hasFilters) ...[
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(onPressed: onClear, child: const Text('Clear filters')),
          ],
        ],
      ),
    );
  }
}

class _UpcomingEventBanner extends StatelessWidget {
  const _UpcomingEventBanner({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.offWhite,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.flutterBlue.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: AppColors.flutterBlue.withAlpha(16),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _BannerImage(event: event),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: _BannerDetails(event: event),
              ),
            ])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xxl),
                  child: _BannerDetails(event: event),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.horizontal(
                    right: Radius.circular(AppSpacing.cardRadius),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AssetImageOrPlaceholder(
                      assetPath: event.imageAsset,
                      placeholderLabel: event.title,
                    ),
                  ),
                ),
              ),
            ]),
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppSpacing.cardRadius)),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: AssetImageOrPlaceholder(
          assetPath: event.imageAsset,
          placeholderLabel: event.title,
        ),
      ),
    );
  }
}

class _BannerDetails extends StatelessWidget {
  const _BannerDetails({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE d MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.flutterBlue.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          ),
          child: Text(dateFormat.format(event.startDateTime),
              style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.flutterBlue, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(event.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Row(children: [
          const Icon(Icons.access_time_outlined,
              size: 16, color: AppColors.neutralGrey),
          const SizedBox(width: 6),
          Text(
              '${timeFormat.format(event.startDateTime)} – ${timeFormat.format(event.endDateTime)}',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.neutralGrey)),
        ]),
        const SizedBox(height: 4),
        Row(children: [
          const Icon(Icons.location_on_outlined,
              size: 16, color: AppColors.neutralGrey),
          const SizedBox(width: 6),
          Expanded(
            child: Text('${event.venueName}, ${event.venueAddress}',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.neutralGrey)),
          ),
        ]),
        const SizedBox(height: AppSpacing.md),
        Text(event.description,
            style: theme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis),
        const SizedBox(height: AppSpacing.xl),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          ElevatedButton.icon(
            onPressed: () => UrlService.open(event.registrationUrl),
            icon: const Icon(Icons.confirmation_num_outlined, size: 18),
            label: const Text('Reserve Your Place'),
          ),
          OutlinedButton.icon(
            onPressed: () => GoRouter.of(context).go('/events/${event.id}'),
            icon: const Icon(Icons.info_outline, size: 18),
            label: const Text('View Details'),
          ),
        ]),
      ],
    );
  }
}

class _PastEventCard extends StatefulWidget {
  const _PastEventCard({required this.event});
  final CommunityEvent event;

  @override
  State<_PastEventCard> createState() => _PastEventCardState();
}

class _PastEventCardState extends State<_PastEventCard> {
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
                    blurRadius: 16,
                    offset: const Offset(0, 4),
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
                      top: Radius.circular(AppSpacing.cardRadius)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: AssetImageOrPlaceholder(
                        assetPath: widget.event.imageAsset,
                        placeholderLabel: widget.event.title),
                  ),
                ),
                if (widget.event.hasRecording)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          color: Colors.red.shade600,
                          borderRadius: BorderRadius.circular(6)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text('Recording',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600)),
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
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.event.title,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  if (widget.event.speakers.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                        widget.event.speakers.map((s) => s.name).join(', '),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.neutralGrey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: AppSpacing.sm),
                  Text(widget.event.description,
                      style: theme.textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
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
