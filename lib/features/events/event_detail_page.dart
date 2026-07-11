import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/placeholder_image.dart';
import '../../data/models/community_event.dart';
import '../../services/url_service.dart';

class EventDetailPage extends ConsumerWidget {
  const EventDetailPage({super.key, required this.eventId});
  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventByIdProvider(eventId));

    return eventAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => const Center(child: Text('Unable to load event.')),
      data: (event) {
        if (event == null) {
          return _NotFoundState();
        }
        return _EventDetailContent(event: event);
      },
    );
  }
}

class _NotFoundState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.event_busy_outlined,
              size: 64, color: AppColors.neutralGrey),
          const SizedBox(height: AppSpacing.md),
          const Text('Event not found'),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () => context.go('/events'),
            child: const Text('View all events'),
          ),
        ],
      ),
    );
  }
}

class _EventDetailContent extends StatelessWidget {
  const _EventDetailContent({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      children: [
        // Hero banner
        Container(
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
              child: isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [_EventHeader(event: event)])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            flex: 3,
                            child: _EventHeader(event: event)),
                        const SizedBox(width: AppSpacing.xxl),
                        Expanded(
                          flex: 2,
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.cardRadius),
                            child: AspectRatio(
                              aspectRatio: 4 / 3,
                              child: AssetImageOrPlaceholder(
                                assetPath: event.imageAsset,
                                placeholderLabel: event.title,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),

        // Main content
        Container(
          color: AppColors.offWhite,
          child: ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical:
                    isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
              ),
              child: isMobile
                  ? _MobileLayout(event: event)
                  : _DesktopLayout(event: event),
            ),
          ),
        ),
      ],
    );
  }
}

class _EventHeader extends StatelessWidget {
  const _EventHeader({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEEE d MMMM yyyy');
    final timeFormat = DateFormat('HH:mm');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          onPressed: () => context.go('/events'),
          icon: const Icon(Icons.arrow_back, size: 16, color: AppColors.lightBlue),
          label: const Text('All Events',
              style: TextStyle(color: AppColors.lightBlue)),
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: AppColors.white.withAlpha(20),
            borderRadius: BorderRadius.circular(AppSpacing.chipRadius),
          ),
          child: Text(
            dateFormat.format(event.startDateTime),
            style: theme.textTheme.labelSmall?.copyWith(
                color: AppColors.lightBlue, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(event.title,
            style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.white, fontWeight: FontWeight.w800)),
        const SizedBox(height: AppSpacing.md),
        _HeaderInfoRow(
            icon: Icons.access_time_outlined,
            text:
                '${timeFormat.format(event.startDateTime)} – ${timeFormat.format(event.endDateTime)}'),
        const SizedBox(height: 6),
        _HeaderInfoRow(
            icon: Icons.location_on_outlined,
            text: event.venueName),
        const SizedBox(height: 6),
        _HeaderInfoRow(
            icon: Icons.map_outlined,
            text: event.venueAddress,
            isLink: true,
            onTap: () => UrlService.open(
                'https://maps.google.com/?q=${Uri.encodeComponent(event.venueAddress)}')),
        const SizedBox(height: AppSpacing.xl),
        Wrap(spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: [
          ElevatedButton.icon(
            onPressed: event.isUpcoming
                ? () => UrlService.open(event.registrationUrl)
                : null,
            icon: const Icon(Icons.confirmation_num_outlined, size: 18),
            label: Text(event.isUpcoming ? 'Reserve Your Place' : 'Event Passed'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightBlue,
              foregroundColor: AppColors.darkNavy,
            ),
          ),
          if (event.isUpcoming)
            OutlinedButton.icon(
              onPressed: () => UrlService.addToGoogleCalendar(
                title: event.title,
                start: event.startDateTime,
                end: event.endDateTime,
                location: event.venueAddress,
                description: event.description,
              ),
              icon: const Icon(Icons.calendar_today_outlined,
                  size: 18, color: AppColors.white),
              label: const Text('Add to Calendar',
                  style: TextStyle(color: AppColors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.white),
              ),
            ),
          if (event.hasRecording)
            OutlinedButton.icon(
              onPressed: () => UrlService.open(event.videoUrl!),
              icon: const Icon(Icons.play_circle_outline,
                  size: 18, color: AppColors.white),
              label: const Text('Watch Recording',
                  style: TextStyle(color: AppColors.white)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.white),
              ),
            ),
        ]),
      ],
    );
  }
}

class _HeaderInfoRow extends StatelessWidget {
  const _HeaderInfoRow({
    required this.icon,
    required this.text,
    this.isLink = false,
    this.onTap,
  });
  final IconData icon;
  final String text;
  final bool isLink;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Row(
      children: [
        Icon(icon, size: 16, color: AppColors.white.withAlpha(180)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: isLink ? AppColors.lightBlue : AppColors.white.withAlpha(200),
              fontSize: 14,
              decoration: isLink ? TextDecoration.underline : null,
              decorationColor: AppColors.lightBlue.withAlpha(150),
            ),
          ),
        ),
      ],
    );
    if (isLink && onTap != null) {
      return GestureDetector(onTap: onTap, child: content);
    }
    return content;
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _MainContent(event: event),
        ),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(
          flex: 2,
          child: _Sidebar(event: event),
        ),
      ],
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MainContent(event: event),
        const SizedBox(height: AppSpacing.xxl),
        _Sidebar(event: event),
      ],
    );
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Description
        Text('About this event',
            style: theme.textTheme.titleLarge?.copyWith(
                color: AppColors.darkNavy, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.md),
        Text(event.description, style: theme.textTheme.bodyLarge),

        // Agenda
        if (event.agenda.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          Text('Agenda',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.darkNavy, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          ...event.agenda.map((item) => _AgendaItem(item: item)),
        ],

        // Speakers
        if (event.speakers.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xxl),
          Text('Speakers',
              style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.darkNavy, fontWeight: FontWeight.w700)),
          const SizedBox(height: AppSpacing.md),
          ...event.speakers
              .map((s) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: _SpeakerCard(speaker: s),
                  )),
        ],

        // Topics
        if (event.topics.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xl),
          Text('Topics covered',
              style: theme.textTheme.labelLarge
                  ?.copyWith(color: AppColors.darkNavy)),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: event.topics.map((t) => Chip(label: Text(t))).toList(),
          ),
        ],
      ],
    );
  }
}

class _AgendaItem extends StatelessWidget {
  const _AgendaItem({required this.item});
  final AgendaItem item;

  IconData get _icon {
    switch (item.type) {
      case AgendaItemType.networking:
        return Icons.people_outline;
      case AgendaItemType.talk:
        return Icons.mic_none_outlined;
      case AgendaItemType.workshop:
        return Icons.build_outlined;
      case AgendaItemType.lightning:
        return Icons.flash_on_outlined;
      case AgendaItemType.break_:
        return Icons.coffee_outlined;
      case AgendaItemType.intro:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 56,
            child: Text(item.time,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.flutterBlue, fontWeight: FontWeight.w700)),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withAlpha(16),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(_icon, size: 16, color: AppColors.flutterBlue),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.darkNavy,
                        fontWeight: FontWeight.w600)),
                if (item.description != null)
                  Text(item.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.neutralGrey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpeakerCard extends StatelessWidget {
  const _SpeakerCard({required this.speaker});
  final EventSpeaker speaker;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AssetImageOrPlaceholder(
                  assetPath: speaker.photoAsset,
                  width: 48,
                  height: 48,
                  placeholderLabel: speaker.name,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(speaker.name,
                        style: theme.textTheme.titleSmall?.copyWith(
                            color: AppColors.darkNavy,
                            fontWeight: FontWeight.w700)),
                    Text('${speaker.role}, ${speaker.company}',
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.neutralGrey)),
                  ],
                ),
              ),
              Row(
                children: [
                  if (speaker.linkedInUrl != null)
                    IconButton(
                      icon: const Icon(Icons.business_outlined, size: 18),
                      color: AppColors.neutralGrey,
                      tooltip: 'LinkedIn',
                      onPressed: () => UrlService.open(speaker.linkedInUrl!),
                    ),
                  if (speaker.gitHubUrl != null)
                    IconButton(
                      icon: const Icon(Icons.code_outlined, size: 18),
                      color: AppColors.neutralGrey,
                      tooltip: 'GitHub',
                      onPressed: () => UrlService.open(speaker.gitHubUrl!),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: AppColors.flutterBlue.withAlpha(16),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(speaker.talkTitle,
                style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.flutterBlue,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(speaker.talkDescription, style: theme.textTheme.bodySmall),
          if (speaker.slidesUrl != null || speaker.videoUrl != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Row(children: [
              if (speaker.slidesUrl != null)
                TextButton.icon(
                  onPressed: () => UrlService.open(speaker.slidesUrl!),
                  icon: const Icon(Icons.slideshow_outlined, size: 16),
                  label: const Text('Slides'),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
              if (speaker.videoUrl != null)
                TextButton.icon(
                  onPressed: () => UrlService.open(speaker.videoUrl!),
                  icon: const Icon(Icons.play_circle_outline, size: 16),
                  label: const Text('Watch'),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                ),
            ]),
          ],
        ],
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Event details',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const Divider(height: AppSpacing.xl),
          _SidebarRow(
              icon: Icons.calendar_today_outlined,
              label: 'Date',
              value: DateFormat('EEEE d MMMM yyyy').format(event.startDateTime)),
          _SidebarRow(
              icon: Icons.access_time_outlined,
              label: 'Time',
              value:
                  '${DateFormat('HH:mm').format(event.startDateTime)} – ${DateFormat('HH:mm').format(event.endDateTime)}'),
          _SidebarRow(
              icon: Icons.location_on_outlined,
              label: 'Venue',
              value: event.venueName),
          _SidebarRow(
              icon: Icons.map_outlined,
              label: 'Address',
              value: event.venueAddress),
          const SizedBox(height: AppSpacing.lg),
          if (event.isUpcoming) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => UrlService.open(event.registrationUrl),
                child: const Text('Reserve Your Place'),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => UrlService.addToGoogleCalendar(
                  title: event.title,
                  start: event.startDateTime,
                  end: event.endDateTime,
                  location: event.venueAddress,
                ),
                icon: const Icon(Icons.calendar_today_outlined, size: 16),
                label: const Text('Add to Calendar'),
              ),
            ),
          ] else if (event.hasRecording) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => UrlService.open(event.videoUrl!),
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: const Text('Watch Recording'),
              ),
            ),
          ],
          if (event.hasSlides) ...[
            const SizedBox(height: AppSpacing.sm),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => UrlService.open(event.slidesUrl!),
                icon: const Icon(Icons.slideshow_outlined, size: 16),
                label: const Text('View Slides'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarRow extends StatelessWidget {
  const _SidebarRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                        color: AppColors.darkNavy, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
