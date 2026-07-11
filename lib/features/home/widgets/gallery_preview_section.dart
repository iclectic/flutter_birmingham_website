import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/placeholder_image.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../data/models/gallery_item.dart';

class GalleryPreviewSection extends ConsumerWidget {
  const GalleryPreviewSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final galleryAsync = ref.watch(galleryItemsProvider);
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
                key: const Key('gallery-preview-heading'),
                child: Row(
                  children: [
                    const Expanded(
                      child: SectionHeading(
                        eyebrow: 'GALLERY',
                        title: 'Moments from our events',
                        subtitle: 'A look at our community in action.',
                      ),
                    ),
                    if (!isMobile)
                      OutlinedButton.icon(
                        onPressed: () => context.go('/gallery'),
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        label: const Text('View Gallery'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              galleryAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (err, stack) => const Text('Unable to load gallery.'),
                data: (items) {
                  final preview = items.take(6).toList();
                  return _GalleryGrid(items: preview);
                },
              ),
              if (isMobile) ...[
                const SizedBox(height: AppSpacing.xl),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () => context.go('/gallery'),
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('View Gallery'),
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
              : 3;
      final spacing = 12.0;
      final itemWidth =
          (constraints.maxWidth - spacing * (columns - 1)) / columns;

      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: items
            .asMap()
            .entries
            .map((entry) => FadeInWidget(
                  key: Key('gallery-preview-${entry.key}'),
                  delay: Duration(milliseconds: entry.key * 80),
                  child: _GalleryTile(
                    item: entry.value,
                    size: itemWidth,
                  ),
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
                      child: const Center(
                        child: Icon(Icons.zoom_in_rounded,
                            color: Colors.white, size: 32),
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
      builder: (context) => _LightboxDialog(item: widget.item),
    );
  }
}

class _LightboxDialog extends StatelessWidget {
  const _LightboxDialog({required this.item});
  final GalleryItem item;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.9;
    return Dialog(
      backgroundColor: AppColors.darkNavy,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: 600),
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
                        Text(
                          item.caption,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        Text(
                          item.eventName,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.white.withAlpha(160),
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: 'Close',
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
