import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter_birmingham_website/app/providers.dart';
import 'package:flutter_birmingham_website/app/theme/app_theme.dart';
import 'package:flutter_birmingham_website/core/widgets/fb_logo.dart';
import 'package:flutter_birmingham_website/core/widgets/section_heading.dart';
import 'package:flutter_birmingham_website/data/content/events.dart';
import 'package:flutter_birmingham_website/data/content/team.dart';
import 'package:flutter_birmingham_website/data/models/community_event.dart';
import 'package:flutter_birmingham_website/data/models/team_member.dart';
import 'package:flutter_birmingham_website/features/events/events_page.dart';
import 'package:flutter_birmingham_website/features/team/team_page.dart';

Widget _testApp(Widget child, {List overrides = const []}) => ProviderScope(
  overrides: [...overrides],
  child: MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

CommunityEvent _event(String id, DateTime start) => CommunityEvent(
  id: id,
  title: 'Event $id',
  description: 'Description',
  startDateTime: start,
  endDateTime: start.add(const Duration(hours: 2)),
  venueName: 'Venue',
  venueAddress: 'Birmingham',
  imageAsset: '',
  topics: const [],
  registrationUrl: 'https://example.com',
);

void main() {
  setUpAll(() {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;
  });

  group('FBLogo', () {
    testWidgets('renders mark and wordmark', (tester) async {
      await tester.pumpWidget(_testApp(const FBLogo(height: 40)));
      expect(find.byType(Image), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('mark-only variant is labelled for screen readers', (
      tester,
    ) async {
      await tester.pumpWidget(
        _testApp(const FBLogo(height: 40, showWordmark: false)),
      );
      expect(find.bySemanticsLabel('Flutter Birmingham logo'), findsOneWidget);
    });
  });

  group('SectionHeading', () {
    testWidgets('renders eyebrow, title and subtitle', (tester) async {
      await tester.pumpWidget(
        _testApp(
          const SectionHeading(
            eyebrow: 'Events',
            title: 'Title',
            subtitle: 'Subtitle',
          ),
        ),
      );
      expect(find.text('EVENTS'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('Subtitle'), findsOneWidget);
    });
  });

  group('Event helpers', () {
    final now = DateTime(2027, 6, 1, 12);
    final all = [
      _event('old', DateTime(2027, 1, 1, 18)),
      _event('next', DateTime(2027, 6, 10, 18)),
      _event('later', DateTime(2027, 9, 10, 18)),
    ];

    test('upcomingEventFrom returns the soonest future event', () {
      expect(upcomingEventFrom(all, now: now)?.id, 'next');
    });

    test('event in progress still counts as upcoming', () {
      final during = DateTime(2027, 6, 10, 19);
      expect(upcomingEventFrom(all, now: during)?.id, 'next');
    });

    test('pastEventsFrom is newest first', () {
      final later = DateTime(2027, 12, 1);
      expect(pastEventsFrom(all, now: later).map((e) => e.id), [
        'later',
        'next',
        'old',
      ]);
    });

    test('returns null when nothing is scheduled', () {
      expect(upcomingEventFrom(all, now: DateTime(2028)), isNull);
    });

    test('event ids are unique', () {
      final ids = events.map((e) => e.id).toSet();
      expect(ids.length, events.length);
    });
  });

  group('Team', () {
    test('has one organiser and two co-organiser slots', () {
      expect(team, hasLength(3));
      expect(team.first.name, 'Ibim Braide');
      expect(team.first.teamRole, TeamRole.organiser);
      expect(team.where((m) => m.isPlaceholder), hasLength(2));
    });

    testWidgets('TeamPage shows organiser and placeholders', (tester) async {
      tester.view.physicalSize = const Size(1400, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_testApp(const TeamPage()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ibim Braide'), findsOneWidget);
      expect(find.text('Organiser'), findsOneWidget);
      expect(find.text('Photo coming soon'), findsNWidgets(2));
    });
  });

  group('EventsPage', () {
    testWidgets('shows empty state when no events', (tester) async {
      tester.view.physicalSize = const Size(1400, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _testApp(
          const EventsPage(),
          overrides: [eventsProvider.overrideWithValue(<CommunityEvent>[])],
        ),
      );
      expect(find.text('The next meetup is being planned'), findsOneWidget);
    });
  });
}
