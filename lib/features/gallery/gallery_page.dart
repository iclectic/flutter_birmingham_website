import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/fade_in_widget.dart';
import '../../core/widgets/placeholder_image.dart';
import '../../core/widgets/section_heading.dart';
import '../../data/models/gallery_item.dart';

class GalleryPage extends ConsumerWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isMobile = Breakpoints.isMobile(context);
    final filter = ref.watch(galleryFilterProvider);
    final filteredAsync = ref.watch(filteredGalleryProvider);

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
                eyebrow: 'GALLERY',
                title: 'Event gallery',
                subtitle:
                    'Moments from Flutter Birmingham events — talks, workshops, and community nights.',
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
                vertical:
                    isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filters
                  _GalleryFilterBar(filter: filter, ref: ref),
                  const SizedBox(height: AppSpacing.xxl),
                  filteredAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (err, stack) => const Text('Unable to load gallery.'),
                    data: (items) {
                      if (items.isEmpty) {
                        return _EmptyGallery(
                          onClear: () => ref
                              .read(galleryFilterProvider.notifier)
                              .clearFilters(),
                        );
                      }
                      return _GalleryGrid(items: items);
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

class _GalleryFilterBar extends StatelessWidget {
  const _GalleryFilterBar({required this.filter, required this.ref});
  final GalleryFilterState filter;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(galleryFilterProvider.notifier);
    final types = GalleryItemType.values;

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        FilterChip(
          label: const Text('All'),
          selected: filter.selectedType == null &&
              filter.selectedYear == null &&
              filter.selectedEventId == null,
          onSelected: (_) => notifier.clearFilters(),
          selectedColor: AppColors.flutterBlue.withAlpha(30),
        ),
        ...types.map((type) => FilterChip(
              label: Text(_typeLabel(type)),
              selected: filter.selectedType == type,
              onSelected: (selected) =>
                  notifier.setType(selected ? type : null),
              selectedColor: AppColors.flutterBlue.withAlpha(30),
              checkmarkColor: AppColors.flutterBlue,
              labelStyle: TextStyle(
                color: filter.selectedType == type
                    ? AppColors.flutterBlue
                    : AppColors.darkNavy,
                fontWeight: filter.selectedType == type
                    ? FontWeight.w600
                    : FontWeight.normal,
                fontSize: 13,
              ),
              side: BorderSide(
                color: filter.selectedType == type
                    ? AppColors.flutterBlue
                    : AppColors.cardBorder,
              ),
              backgroundColor: AppColors.white,
            )),
      ],
    );
  }

  String _typeLabel(GalleryItemType type) {
    switch (type) {
      case GalleryItemType.speaker:
        return 'Speakers';
      case GalleryItemType.audience:
        return 'Audience';
      case GalleryItemType.networking:
        return 'Networking';
      case GalleryItemType.workshop:
        return 'Workshops';
      case GalleryItemType.venue:
        return 'Venue';
      case GalleryItemType.general:
        return 'General';
    }
  }
}

class _GalleryGrid extends StatelessWidget {
  const _GalleryGrid({required this.items});
  final List<GalleryItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final columns = Breakpoints.isMobile(context)
          ? 2
          : Breakpoints.isTablet(context)
              ? 3
              : 4;
      const spacing = 12.0;
      final itemWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: items
            .asMap()
            .entries
            .map((e) => FadeInWidget(
                  key: Key('gallery-${e.key}'),
                  delay: Duration(milliseconds: (e.key % 4) * 60),
                  child: _GalleryTile(item: e.value, size: itemWidth),
                ))
            .toList(),
      );
    });
  }
}

class _GalleryTile extends StatefulWidget {
  const _GalleryTile({required this.item, required this.size});
  final GalleryItem item;
  final double size;

  @override
  State<_GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<_GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showLightbox(context),
        child: Semantics(
          label: widget.item.caption,
          button: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.darkNavy.withAlpha(30),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      )
                    ]
                  : [],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AssetImageOrPlaceholder(
                    assetPath: widget.item.imageAsset,
                    placeholderLabel: widget.item.caption,
                  ),
                  AnimatedOpacity(
                    opacity: _hovered ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      color: AppColors.darkNavy.withAlpha(100),
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.item.caption,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLightbox(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => _LightboxDialog(item: widget.item),
    );
  }
}

class _LightboxDialog extends StatelessWidget {
  const _LightboxDialog({required this.item});
  final GalleryItem item;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.darkNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.9,
          maxHeight: 700,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppSpacing.cardRadius)),
                child: AssetImageOrPlaceholder(
                  assetPath: item.imageAsset,
                  placeholderLabel: item.caption,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.caption,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w600,
                                    )),
                        Text(item.eventName,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.white.withAlpha(160),
                                    )),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
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

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({required this.onClear});
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
      child: Column(children: [
        const Icon(Icons.photo_library_outlined,
            size: 48, color: AppColors.neutralGrey),
        const SizedBox(height: AppSpacing.md),
        const Text('No images match your filters'),
        const SizedBox(height: AppSpacing.md),
        ElevatedButton(onPressed: onClear, child: const Text('Clear filters')),
      ]),
    );
  }
}
