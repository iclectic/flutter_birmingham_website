import 'package:go_router/go_router.dart';

import '../features/about/about_page.dart';
import '../features/code_of_conduct/code_of_conduct_page.dart';
import '../features/contact/contact_page.dart';
import '../features/events/event_detail_page.dart';
import '../features/events/events_page.dart';
import '../features/gallery/gallery_page.dart';
import '../features/home/home_page.dart';
import '../features/team/team_page.dart';
import '../core/widgets/not_found_page.dart';
import '../core/widgets/app_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  errorBuilder: (context, state) => const NotFoundPage(),
  routes: [
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomePage(),
          ),
        ),
        GoRoute(
          path: '/events',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: EventsPage(),
          ),
        ),
        GoRoute(
          path: '/events/:eventId',
          pageBuilder: (context, state) {
            final eventId = state.pathParameters['eventId']!;
            return NoTransitionPage(
              child: EventDetailPage(eventId: eventId),
            );
          },
        ),
        GoRoute(
          path: '/about',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AboutPage(),
          ),
        ),
        GoRoute(
          path: '/team',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TeamPage(),
          ),
        ),
        GoRoute(
          path: '/gallery',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: GalleryPage(),
          ),
        ),
        GoRoute(
          path: '/code-of-conduct',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: CodeOfConductPage(),
          ),
        ),
        GoRoute(
          path: '/contact',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ContactPage(),
          ),
        ),
      ],
    ),
  ],
);
