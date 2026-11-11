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
                    'We want everyone to feel safe and welcome at our events. This '
                    'is what we expect from everyone who comes along.',
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

  static const _cc0Url = 'https://creativecommons.org/publicdomain/zero/1.0/';
  static const _gdgUrl =
      'https://support.google.com/developergroups/answer/3340512?hl=en';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bodyStyle = theme.textTheme.bodyLarge?.copyWith(height: 1.8);
    final linkStyle = bodyStyle?.copyWith(
      color: AppColors.flutterBlue,
      fontWeight: FontWeight.w600,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.flutterBlue,
    );

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
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(text, style: bodyStyle),
    );

    Widget numbered(int n, String lead, String text) => Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$n.',
              style: bodyStyle?.copyWith(
                color: AppColors.flutterBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '$lead ',
                    style: const TextStyle(
                      color: AppColors.darkNavy,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(text: text),
                ],
              ),
              style: bodyStyle,
            ),
          ),
        ],
      ),
    );

    Widget link(String label, String url) => InkWell(
      onTap: () => UrlService.open(url),
      child: Text(label, style: linkStyle),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        body(
          'Flutter Birmingham is part of the Flutter Meetup Network and follows '
          'its Event Code of Conduct & Anti-Harassment Policy, set out in full '
          'below.',
        ),
        h2('Event Code of Conduct & Anti-Harassment Policy'),
        body(
          'The Flutter Meetup Network is dedicated to providing a harassment-free '
          'and inclusive event experience for everyone regardless of gender '
          'identity and expression, sexual orientation, disabilities, '
          'neurodiversity, physical appearance, body size, ethnicity, '
          'nationality, race, age, religion, or other protected category. We do '
          'not tolerate harassment of event participants in any form. We take '
          'violations of our policy seriously and will respond appropriately.',
        ),
        body(
          'All participants of Flutter Meetup Network events must abide by the '
          'following policy:',
        ),
        numbered(
          1,
          'Be excellent to each other.',
          'We want the event to be an excellent experience for everyone '
              'regardless of gender identity and expression, sexual '
              'orientation, disabilities, neurodiversity, physical appearance, '
              'body size, ethnicity, nationality, race, age, religion, or other '
              'protected category. Treat everyone with respect. Participate '
              'while acknowledging that everyone deserves to be here, and each '
              'of us has the right to enjoy our experience without fear of '
              'harassment, discrimination, or condescension, whether blatant or '
              "via micro-aggressions. Jokes shouldn't demean others. Consider "
              'what you are saying and how it would feel if it were said to or '
              'about you.',
        ),
        numbered(
          2,
          'Speak up if you see or hear something.',
          'Harassment is not tolerated, and you are empowered to politely '
              'engage when you or others are disrespected. The person making '
              'you feel uncomfortable may not be aware of what they are doing, '
              'and politely bringing their behaviour to their attention is '
              'encouraged. If a participant engages in harassing or '
              'uncomfortable behaviour, the event organisers may take any action '
              'they deem appropriate, including warning or expelling the '
              'offender from the event with no refund. If you are being '
              'harassed or feel uncomfortable, notice that someone else is being '
              'harassed, or have any other concerns, please contact a member of '
              'the event staff immediately.',
        ),
        numbered(
          3,
          'Harassment is not tolerated.',
          'Harassment includes, but is not limited to: verbal language that '
              'reinforces social structures of domination related to gender '
              'identity and expression, sexual orientation, disabilities, '
              'neurodiversity, physical appearance, body size, ethnicity, '
              'nationality, race, age, religion, or other protected category; '
              'sexual imagery in public spaces; deliberate intimidation; '
              'stalking; following; harassing photography or recording; '
              'sustained disruption of talks or other events; offensive verbal '
              'language; inappropriate physical contact; and unwelcome sexual '
              'attention. Participants asked to stop any harassing behaviour are '
              'expected to comply immediately.',
        ),
        numbered(
          4,
          'Practise saying "Yes and" to each other.',
          "It's a theatre improv technique to build on each other's ideas. We "
              'all benefit when we create together.',
        ),
        body(
          'This policy extends to talks, forums, workshops, codelabs, social '
          'media, parties, hallway conversations, all attendees, partners, '
          'sponsors, volunteers, event staff, etc. You catch our drift. We '
          'reserve the right to refuse admittance to, or remove any person from, '
          'any Flutter Meetup Network hosted event (including future Flutter '
          'Meetup Network events) at any time in its sole discretion. This '
          'includes, but is not limited to, attendees behaving in a disorderly '
          'manner or failing to comply with this policy, and the terms and '
          'conditions herein. If a participant engages in harassing or '
          'uncomfortable behaviour, the event organisers may take any action '
          'they deem appropriate, including warning or expelling the offender '
          'from the event with no refund.',
        ),
        body(
          'Our event staff can usually be identified by special badges/attire. '
          'Our zero tolerance policy means that we will look into and review '
          'every allegation of violation of this Code of Conduct and respond '
          'appropriately. Please note, while we take all concerns raised '
          'seriously, we will use our discretion as to determining when and how '
          'to follow up on reported incidents, and may decline to take any '
          'further action and/or may direct the participant to other resources '
          'for resolution.',
        ),
        body(
          'Event staff will be happy to help participants contact hotel/venue '
          'security or local law enforcement, provide escorts, or otherwise '
          'assist those experiencing discomfort or harassment to feel safe for '
          'the duration of the event. We value your attendance.',
        ),
        body(
          'Exhibiting partners, sponsors or vendor booths, or similar activities '
          'are also subject to this policy. In particular, exhibitors should not '
          'use sexualised images, activities, or other material. Booth staff '
          '(including volunteers) should not use sexualised '
          'clothing/uniforms/costumes, or otherwise create a sexualised '
          'environment. Participants and exhibiting partners or sponsors '
          'disobeying this policy will be notified and are expected to stop any '
          'offending behaviour immediately.',
        ),
        h2('Why this policy is important'),
        body(
          'Harassment at events and in online communities is unfortunately '
          'common. Creating an official policy aims to improve this by making it '
          'clear that harassment of anyone for any reason is not acceptable '
          'within our events and communities. This policy may prevent '
          'harassment by clearly defining expectations for behaviour, aims to '
          'provide reassurance, and encourages people who have had bad '
          'experiences at other events to participate in this one.',
        ),
        h2('Reporting a concern'),
        body(
          'At a Flutter Birmingham event, speak to any organiser. You can also '
          'email the organisers at any time:',
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
                  child: Text(AppStrings.conductEmail, style: linkStyle),
                ),
              ),
            ],
          ),
        ),
        h2('Licence and attribution'),
        body(
          'This policy is licensed under the Creative Commons Zero licence. It '
          'is based on the GDG event code of conduct.',
        ),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.xs,
          children: [
            link('Creative Commons Zero (CC0)', _cc0Url),
            link('GDG event code of conduct', _gdgUrl),
          ],
        ),
      ],
    );
  }
}
