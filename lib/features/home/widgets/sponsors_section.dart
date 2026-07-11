import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../core/widgets/placeholder_image.dart';
import '../../../core/widgets/section_heading.dart';
import '../../../data/models/sponsor.dart';
import '../../../services/url_service.dart';

class SponsorsSection extends ConsumerWidget {
  const SponsorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sponsors = ref.watch(sponsorsProvider);
    final isMobile = Breakpoints.isMobile(context);

    final grouped = <SponsorCategory, List<Sponsor>>{};
    for (final sponsor in sponsors) {
      grouped.putIfAbsent(sponsor.category, () => []).add(sponsor);
    }

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
                key: const Key('sponsors-heading'),
                child: Row(
                  children: [
                    const Expanded(
                      child: SectionHeading(
                        eyebrow: 'OUR PARTNERS',
                        title: 'Sponsors & partners',
                        subtitle:
                            'Flutter Birmingham is made possible by the generous support of our partners.',
                      ),
                    ),
                    if (!isMobile)
                      ElevatedButton(
                        onPressed: () =>
                            UrlService.open(AppStrings.sponsorshipUrl),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.offWhite,
                            foregroundColor: AppColors.flutterBlue,
                            side: const BorderSide(
                                color: AppColors.flutterBlue)),
                        child: const Text('Support Flutter Birmingham'),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              ...grouped.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                    child: FadeInWidget(
                      key: Key('sponsor-group-${entry.key.name}'),
                      child: _SponsorGroup(
                        category: entry.key,
                        sponsors: entry.value,
                      ),
                    ),
                  )),
              if (isMobile) ...[
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        UrlService.open(AppStrings.sponsorshipUrl),
                    child: const Text('Support Flutter Birmingham'),
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

class _SponsorGroup extends StatelessWidget {
  const _SponsorGroup({required this.category, required this.sponsors});
  final SponsorCategory category;
  final List<Sponsor> sponsors;

  String get _categoryLabel {
    switch (category) {
      case SponsorCategory.venue:
        return 'Venue Partners';
      case SponsorCategory.technology:
        return 'Technology Sponsors';
      case SponsorCategory.refreshments:
        return 'Refreshment Sponsors';
      case SponsorCategory.community:
        return 'Community Partners';
      case SponsorCategory.media:
        return 'Media Partners';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _categoryLabel,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.neutralGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: sponsors
              .map((s) => _SponsorLogo(sponsor: s))
              .toList(),
        ),
      ],
    );
  }
}

class _SponsorLogo extends StatefulWidget {
  const _SponsorLogo({required this.sponsor});
  final Sponsor sponsor;

  @override
  State<_SponsorLogo> createState() => _SponsorLogoState();
}

class _SponsorLogoState extends State<_SponsorLogo> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Semantics(
        label: widget.sponsor.accessibilityDescription,
        button: true,
        child: GestureDetector(
          onTap: () => UrlService.open(widget.sponsor.websiteUrl),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 160,
            height: 80,
            decoration: BoxDecoration(
              color: _hovered ? AppColors.offWhite : AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
              border: Border.all(
                color: _hovered
                    ? AppColors.flutterBlue.withAlpha(60)
                    : AppColors.cardBorder,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.flutterBlue.withAlpha(16),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Center(
                child: AssetImageOrPlaceholder(
                  assetPath: widget.sponsor.logoAsset,
                  placeholderLabel: widget.sponsor.name,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
