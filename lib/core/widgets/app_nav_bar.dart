import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';
import '../responsive/breakpoints.dart';
import 'fb_logo.dart';

class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key});

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  final bool _scrolled = false;

  static const _navItems = [
    _NavItem('Home', '/'),
    _NavItem('Events', '/events'),
    _NavItem('About', '/about'),
    _NavItem('Team', '/team'),
    _NavItem('Gallery', '/gallery'),
    _NavItem('Code of Conduct', '/code-of-conduct'),
    _NavItem('Contact', '/contact'),
  ];

  void _openDrawer(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _MobileNavDrawer(navItems: _navItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    final isTablet = Breakpoints.isTablet(context);
    final showHamburger = isMobile || isTablet;
    final currentLocation = GoRouterState.of(context).uri.toString();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: AppSpacing.navHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: _scrolled
            ? [
                BoxShadow(
                  color: AppColors.darkNavy.withAlpha(20),
                  blurRadius: 16,
                  offset: const Offset(0, 2),
                )
              ]
            : [
                BoxShadow(
                  color: AppColors.cardBorder,
                  blurRadius: 0,
                  offset: const Offset(0, 1),
                )
              ],
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 48,
            ),
            child: Row(
              children: [
                Semantics(
                  label: 'Flutter Birmingham home',
                  child: GestureDetector(
                    onTap: () => context.go('/'),
                    child: const FBLogo(height: 36),
                  ),
                ),
                const Spacer(),
                if (!showHamburger) ...[
                  ..._navItems.map((item) => _NavLink(
                        item: item,
                        isActive: currentLocation == item.route ||
                            (item.route != '/' &&
                                currentLocation.startsWith(item.route)),
                      )),
                  const SizedBox(width: AppSpacing.md),
                  _JoinButton(),
                ] else ...[
                  Semantics(
                    label: 'Open navigation menu',
                    child: IconButton(
                      icon: const Icon(Icons.menu_rounded),
                      color: AppColors.darkNavy,
                      iconSize: 28,
                      onPressed: () => _openDrawer(context),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.label, this.route);
  final String label;
  final String route;
}

class _NavLink extends StatefulWidget {
  const _NavLink({required this.item, required this.isActive});
  final _NavItem item;
  final bool isActive;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.item.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: widget.isActive
                      ? AppColors.flutterBlue
                      : _hovered
                          ? AppColors.brightBlue
                          : AppColors.darkNavy,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: widget.isActive || _hovered ? 24 : 0,
                decoration: BoxDecoration(
                  color: AppColors.flutterBlue,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.go('/events'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      child: const Text('Join the Community'),
    );
  }
}

class _MobileNavDrawer extends StatelessWidget {
  const _MobileNavDrawer({required this.navItems});
  final List<_NavItem> navItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.85,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.lg,
            ),
            child: Row(
              children: [
                const FBLogo(height: 32),
                const Spacer(),
                Semantics(
                  label: 'Close navigation menu',
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.darkNavy,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              children: [
                ...navItems.map((item) => ListTile(
                      title: Text(
                        item.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.darkNavy,
                            ),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(item.route);
                      },
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xl,
                        vertical: AppSpacing.xs,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.go('/events');
                      },
                      child: const Text('Join the Community'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Text(
                    AppStrings.independentNotice,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutralGrey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
