import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fade_in_widget.dart';
import '../../../services/url_service.dart';

class SpeakerCtaSection extends StatelessWidget {
  const SpeakerCtaSection({super.key});

  static const _talkTypes = [
    'Technical deep-dives',
    'Case studies and real-world projects',
    'Lightning talks (5–10 minutes)',
    'Hands-on workshops',
    'Live demonstrations',
    'Beginner-friendly sessions',
    'Lessons learned from production apps',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      color: AppColors.white,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
          ),
          child: FadeInWidget(
            key: const Key('speaker-cta'),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFEFF6FF),
                    Color(0xFFE0F0FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius + 8),
                border: Border.all(color: AppColors.flutterBlue.withAlpha(40)),
              ),
              padding: EdgeInsets.all(isMobile ? AppSpacing.xl : AppSpacing.xxxl),
              child: isMobile
                  ? _MobileSpeakerContent()
                  : _DesktopSpeakerContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopSpeakerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: _SpeakerText()),
        const SizedBox(width: AppSpacing.xxl),
        Expanded(flex: 2, child: _TalkTypeList()),
      ],
    );
  }
}

class _MobileSpeakerContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SpeakerText(),
        const SizedBox(height: AppSpacing.xl),
        _TalkTypeList(),
      ],
    );
  }
}

class _SpeakerText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            'SPEAK AT FLUTTER BIRMINGHAM',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.flutterBlue,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Have something to share with the Flutter community?',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: AppColors.darkNavy,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Flutter Birmingham welcomes speakers of all experience levels. '
          'Whether it\'s your first talk or your fiftieth, we\'ll support you '
          'every step of the way.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        ElevatedButton.icon(
          onPressed: () => UrlService.open(AppStrings.speakerFormUrl),
          icon: const Icon(Icons.mic_none_outlined, size: 20),
          label: const Text('Submit a Talk'),
        ),
      ],
    );
  }
}

class _TalkTypeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We welcome:',
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.darkNavy,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ...SpeakerCtaSection._talkTypes.map(
          (type) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.flutterBlue,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(type, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
