import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../responsive/breakpoints.dart';
import '../../services/url_service.dart';
import 'fb_logo.dart';

class NavItem {
  const NavItem(this.label, this.route) : url = null;
  const NavItem.external(this.label, String this.url) : route = '';
  final String label;
  final String route;
  final String? url;

  bool isActive(String location) {
    if (url != null) return false;
    return route == '/'
        ? location == '/'
        : location == route || location.startsWith('$route/');
  }

  void open(BuildContext context) {
    if (url != null) {
      UrlService.open(url!);
    } else {
      context.go(route);
    }
  }
}

const navItems = [
  NavItem('Home', '/'),
  NavItem.external('Events', AppStrings.meetupUrl),
  NavItem('Team', '/team'),
  NavItem('Code of Conduct', '/code-of-conduct'),
];

class AppNavBar extends StatelessWidget {
  const AppNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = !Breakpoints.isDesktop(context);
    final location = GoRouterState.of(context).uri.path;

    return Container(
      height: AppSpacing.navHeight,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Breakpoints.isMobile(context) ? 20 : 48,
            ),
            child: Row(
              children: [
                Semantics(
                  link: true,
                  label: 'Flutter Birmingham home',
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => context.go('/'),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: FBLogo(height: 40),
                    ),
                  ),
                ),
                const Spacer(),
                if (!compact) ...[
                  for (final item in navItems)
                    _NavLink(item: item, active: item.isActive(location)),
                  const SizedBox(width: AppSpacing.md),
                  FilledButton(
                    onPressed: () => UrlService.open(AppStrings.meetupUrl),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 14,
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    child: const Text('Join on Meetup'),
                  ),
                ] else
                  IconButton(
                    tooltip: 'Open menu',
                    icon: const Icon(Icons.menu_rounded),
                    color: AppColors.ink,
                    iconSize: 28,
                    onPressed: () => showModalBottomSheet<void>(
                      context: context,
                      showDragHandle: true,
                      backgroundColor: AppColors.white,
                      builder: (_) => _MobileMenu(location: location),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.item, required this.active});
  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: TextButton(
        onPressed: () => item.open(context),
        style: TextButton.styleFrom(
          foregroundColor: active ? AppColors.action : AppColors.body,
          backgroundColor: active ? AppColors.tint100 : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: const StadiumBorder(),
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        child: Text(item.label),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  const _MobileMenu({required this.location});
  final String location;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final item in navItems)
              ListTile(
                title: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: item.isActive(location)
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: item.isActive(location)
                        ? AppColors.action
                        : AppColors.ink,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                selected: item.isActive(location),
                selectedTileColor: AppColors.tint100,
                onTap: () {
                  Navigator.of(context).pop();
                  item.open(context);
                },
              ),
            const SizedBox(height: AppSpacing.md),
            FilledButton(
              onPressed: () => UrlService.open(AppStrings.meetupUrl),
              child: const Text('Join on Meetup'),
            ),
          ],
        ),
      ),
    );
  }
}
