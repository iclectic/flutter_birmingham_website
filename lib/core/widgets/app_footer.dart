import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../responsive/breakpoints.dart';
import '../responsive/responsive_layout.dart';
import '../../services/url_service.dart';
import 'fb_logo.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const _navLinks = [
    _FooterLink('Home', '/'),
    _FooterLink('Events', '/events'),
    _FooterLink('About', '/about'),
    _FooterLink('Team', '/team'),
    _FooterLink('Gallery', '/gallery'),
    _FooterLink('Code of Conduct', '/code-of-conduct'),
    _FooterLink('Contact', '/contact'),
  ];

  static const _socialLinks = [
    _SocialLink('Meetup', AppStrings.meetupUrl, Icons.people_outline),
    _SocialLink('LinkedIn', AppStrings.linkedInUrl, Icons.business_outlined),
    _SocialLink('YouTube', AppStrings.youTubeUrl, Icons.play_circle_outline),
    _SocialLink('GitHub', AppStrings.gitHubUrl, Icons.code_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      color: AppColors.darkNavy,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl,
          ),
          child: isMobile ? _MobileFooter() : _DesktopFooter(),
        ),
      ),
    );
  }
}

class _FooterLink {
  const _FooterLink(this.label, this.route);
  final String label;
  final String route;
}

class _SocialLink {
  const _SocialLink(this.label, this.url, this.icon);
  final String label;
  final String url;
  final IconData icon;
}

class _DesktopFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const navLinks = AppFooter._navLinks;
    const socialLinks = AppFooter._socialLinks;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FBLogo(height: 36, light: true),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.appDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.white.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: socialLinks
                        .map((s) => Padding(
                              padding: const EdgeInsets.only(right: AppSpacing.sm),
                              child: _SocialIconButton(link: s),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xxxl),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Links',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...navLinks.map((link) => _FooterNavLink(link: link)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xxl),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Get Involved',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: AppColors.white,
                      fontSize: 13,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _FooterActionLink(
                    label: 'Attend an Event',
                    onTap: () => UrlService.open(AppStrings.meetupUrl),
                  ),
                  _FooterActionLink(
                    label: 'Speak at an Event',
                    onTap: () => UrlService.open(AppStrings.speakerFormUrl),
                  ),
                  _FooterActionLink(
                    label: 'Become a Sponsor',
                    onTap: () => UrlService.open(AppStrings.sponsorshipUrl),
                  ),
                  _FooterActionLink(
                    label: 'Contact Us',
                    onTap: () => UrlService.openEmail(AppStrings.contactEmail),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        const Divider(color: Color(0xFF1E3A5F)),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(
                AppStrings.copyright,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.white.withAlpha(100),
                    ),
              ),
            ),
            _FooterBottomLink(
              label: 'Privacy Notice',
              onTap: () => context.go('/code-of-conduct'),
            ),
            const SizedBox(width: AppSpacing.md),
            _FooterBottomLink(
              label: 'Code of Conduct',
              onTap: () => context.go('/code-of-conduct'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.independentNotice,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.white.withAlpha(80),
                fontSize: 11,
              ),
        ),
      ],
    );
  }
}

class _MobileFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const socialLinks = AppFooter._socialLinks;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const FBLogo(height: 32, light: true),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.appDescription,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.white.withAlpha(160),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: socialLinks
              .map((s) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                    child: _SocialIconButton(link: s),
                  ))
              .toList(),
        ),
        const SizedBox(height: AppSpacing.xxl),
        const Divider(color: Color(0xFF1E3A5F)),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.copyright,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.white.withAlpha(100),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.independentNotice,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.white.withAlpha(80),
            fontSize: 11,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _FooterNavLink extends StatelessWidget {
  const _FooterNavLink({required this.link});
  final _FooterLink link;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(link.route),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.white.withAlpha(180),
      ),
      child: Text(link.label, style: const TextStyle(fontSize: 14)),
    );
  }
}

class _FooterActionLink extends StatelessWidget {
  const _FooterActionLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.white.withAlpha(180),
      ),
      child: Text(label, style: const TextStyle(fontSize: 14)),
    );
  }
}

class _FooterBottomLink extends StatelessWidget {
  const _FooterBottomLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.lightBlue.withAlpha(200),
              decoration: TextDecoration.underline,
              decorationColor: AppColors.lightBlue.withAlpha(120),
            ),
      ),
    );
  }
}

class _SocialIconButton extends StatefulWidget {
  const _SocialIconButton({required this.link});
  final _SocialLink link;

  @override
  State<_SocialIconButton> createState() => _SocialIconButtonState();
}

class _SocialIconButtonState extends State<_SocialIconButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: Semantics(
        label: widget.link.label,
        button: true,
        child: GestureDetector(
          onTap: () => UrlService.open(widget.link.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.flutterBlue
                  : AppColors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(AppSpacing.buttonRadius),
            ),
            child: Icon(
              widget.link.icon,
              color: AppColors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
