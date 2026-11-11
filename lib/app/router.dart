import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_colors.dart';
import '../core/widgets/app_shell.dart';
import '../core/widgets/not_found_page.dart';
import '../features/code_of_conduct/code_of_conduct_page.dart';
import '../features/home/home_page.dart';
import '../features/team/team_page.dart';

const _siteName = 'Flutter Birmingham';

Page<void> _page(String title, Widget child) => NoTransitionPage(
  child: Title(
    title: title.isEmpty
        ? '$_siteName | Flutter & Dart meetup'
        : '$title | $_siteName',
    color: AppColors.blue,
    child: child,
  ),
);

/// Older URLs. Events now live on Meetup (the server redirects `/events`
/// there); the rest are sections on the home page.
const _legacyRoutes = {'/about', '/gallery', '/contact', '/events'};

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final path = state.uri.path;
    return _legacyRoutes.contains(path) || path.startsWith('/events/')
        ? '/'
        : null;
  },
  errorPageBuilder: (context, state) =>
      _page('Page not found', const NotFoundPage()),
  routes: [
    ShellRoute(
      builder: (context, state, child) =>
          AppShell(location: state.uri.path, child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _page('', const HomePage()),
        ),
        GoRoute(
          path: '/team',
          pageBuilder: (context, state) => _page('Team', const TeamPage()),
        ),
        GoRoute(
          path: '/code-of-conduct',
          pageBuilder: (context, state) =>
              _page('Code of Conduct', const CodeOfConductPage()),
        ),
      ],
    ),
  ],
);
