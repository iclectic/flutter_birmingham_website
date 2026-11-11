import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/responsive/breakpoints.dart';
import '../../core/responsive/responsive_layout.dart';
import '../../core/widgets/section_heading.dart';
import '../../services/url_service.dart';

class CodeOfConductPage extends StatelessWidget {
  const CodeOfConductPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Column(
      children: [
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
                eyebrow: 'COMMUNITY',
                title: 'Code of Conduct',
                subtitle:
                    'Flutter Birmingham is dedicated to providing a safe, inclusive, and respectful experience for everyone.',
                light: true,
              ),
            ),
          ),
        ),
        Container(
          color: AppColors.offWhite,
          child: ContentContainer(
            maxWidth: AppSpacing.maxTextWidth + 120,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile
                    ? AppSpacing.sectionMobile
                    : AppSpacing.section,
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                  border: Border.all(color: AppColors.cardBorder),
                ),
                child: const _CoCContent(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CoCContent extends StatelessWidget {
  const _CoCContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget h2(String text) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.headlineSmall?.copyWith(
          color: AppColors.darkNavy,
          fontWeight: FontWeight.w700,
        ),
      ),
    );

    Widget body(String text) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(height: 1.8),
      ),
    );

    Widget bullet(String text) => Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: CircleAvatar(
              radius: 3,
              backgroundColor: AppColors.flutterBlue,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.7),
            ),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        h2('Our Community Commitment'),
        body(
          'Flutter Birmingham is committed to providing a welcoming, safe, and inclusive '
          'experience for all attendees, speakers, sponsors, organisers, and volunteers, '
          'regardless of gender, gender identity and expression, sexual orientation, disability, '
          'physical appearance, body size, age, race, ethnicity, nationality, religion, '
          'political views, level of experience, or any other personal characteristics.',
        ),
        body(
          'We do not tolerate harassment, discrimination, or exclusionary behaviour in any form. '
          'This Code of Conduct applies to all Flutter Birmingham spaces, including in-person '
          'events, online platforms, social media, and any other community communications.',
        ),
        h2('Expected Behaviour'),
        body('We ask all community members to:'),
        bullet('Be kind, respectful, and considerate towards others.'),
        bullet('Use welcoming and inclusive language.'),
        bullet('Be supportive of people at all experience levels.'),
        bullet('Accept constructive feedback graciously.'),
        bullet('Focus on what is best for the community as a whole.'),
        bullet('Show empathy and patience towards other community members.'),
        bullet('Respect differing viewpoints and experiences.'),
        bullet(
          'Refrain from sharing others\' personal information without consent.',
        ),
        h2('Unacceptable Behaviour'),
        body(
          'The following behaviours are considered unacceptable within our community:',
        ),
        bullet(
          'Harassment of any kind, including offensive comments, deliberate intimidation, '
          'stalking, following, unwanted photography or recording, sustained disruption, '
          'inappropriate physical contact, and unwelcome sexual attention.',
        ),
        bullet(
          'Discriminatory jokes, language, or imagery related to any personal characteristic.',
        ),
        bullet('Threatening or violent language directed at any person.'),
        bullet('Posting or displaying sexually explicit or violent material.'),
        bullet(
          'Personal or political attacks, public or private, directed at community members.',
        ),
        bullet(
          'Other conduct that could reasonably be considered inappropriate in a professional setting.',
        ),
        h2('Event Conduct'),
        body(
          'At Flutter Birmingham events, attendees are expected to behave professionally and '
          'courteously at all times. Venue staff, event organisers, and speakers are to be '
          'treated with respect. Any behaviour that disrupts the event or makes other attendees '
          'feel unsafe may result in removal from the event without warning or refund.',
        ),
        h2('Reporting a Concern'),
        body(
          'If you experience or witness unacceptable behaviour, or have any concerns, '
          'please report it to a Flutter Birmingham organiser as soon as possible. '
          'At in-person events, you can approach any organiser directly. You may also '
          'report concerns by email to:',
        ),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.flutterBlue.withAlpha(12),
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            border: Border.all(color: AppColors.flutterBlue.withAlpha(40)),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.email_outlined,
                color: AppColors.flutterBlue,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: InkWell(
                  onTap: () => UrlService.openEmail(
                    AppStrings.conductEmail,
                    subject: 'Code of Conduct report',
                  ),
                  child: Text(
                    AppStrings.conductEmail,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.flutterBlue,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.flutterBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        h2('Confidentiality'),
        body(
          'All reports will be handled with discretion. We will not share identifying '
          'information about the reporter without their explicit consent. We are committed '
          'to protecting reporters from retaliation.',
        ),
        h2('Enforcement'),
        body(
          'Flutter Birmingham organisers will review all reports and take whatever action '
          'they deem appropriate. This may include a warning, removal from an event, '
          'or a ban from future events. In cases involving illegal activity, we will '
          'cooperate with relevant authorities.',
        ),
        body(
          'We are committed to applying this Code of Conduct fairly and consistently. '
          'Organisers who violate the Code of Conduct may face the same consequences '
          'as other community members.',
        ),
        h2('Contact'),
        body(
          'For any questions about this Code of Conduct or to make a report, please contact '
          'the Flutter Birmingham team. Our contact details are available on the Contact page.',
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
          ),
          child: Text(
            'This Code of Conduct was last updated in 2024 and will be reviewed annually. '
            'It is inspired by, but independent of, the Google Developer Community guidelines '
            'and the Contributor Covenant.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.neutralGrey,
            ),
          ),
        ),
      ],
    );
  }
}
