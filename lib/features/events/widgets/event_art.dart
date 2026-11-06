import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/fb_logo.dart';
import '../../../core/widgets/placeholder_image.dart';
import '../../../data/models/community_event.dart';

/// Event banner image, falling back to a branded tile when none is set.
class EventArt extends StatelessWidget {
  const EventArt({super.key, required this.event});
  final CommunityEvent event;

  @override
  Widget build(BuildContext context) {
    if (event.hasImage) {
      return AssetImageOrPlaceholder(
        assetPath: event.imageAsset,
        placeholderLabel: event.title,
      );
    }
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.tint100, AppColors.tint300],
        ),
      ),
      child: LayoutBuilder(
        builder: (context, c) => Center(
          child: FBLogo(
            height: c.biggest.shortestSide * 0.6,
            showWordmark: false,
          ),
        ),
      ),
    );
  }
}
