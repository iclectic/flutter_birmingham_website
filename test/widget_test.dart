import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'package:flutter_birmingham_website/app/theme/app_theme.dart';
import 'package:flutter_birmingham_website/core/constants/app_strings.dart';
import 'package:flutter_birmingham_website/core/widgets/app_nav_bar.dart';
import 'package:flutter_birmingham_website/core/widgets/fb_logo.dart';
import 'package:flutter_birmingham_website/core/widgets/section_heading.dart';
import 'package:flutter_birmingham_website/data/content/team.dart';
import 'package:flutter_birmingham_website/data/models/team_member.dart';
import 'package:flutter_birmingham_website/features/team/team_page.dart';

Widget _testApp(Widget child, {List overrides = const []}) => ProviderScope(
  overrides: [...overrides],
  child: MaterialApp(
    theme: AppTheme.light,
    home: Scaffold(body: SingleChildScrollView(child: child)),
  ),
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

  group('Navigation', () {
    test('Events links out to Meetup', () {
      final item = navItems.firstWhere((i) => i.label == 'Events');
      expect(item.url, AppStrings.meetupUrl);
      expect(item.isActive('/'), isFalse);
    });
  });

  group('Team', () {
    test('has one organiser and two co-organisers', () {
      expect(team, hasLength(3));
      expect(team.first.name, 'Ibim Braide');
      expect(team.first.teamRole, TeamRole.organiser);
      expect(team[1].name, 'Franklin Oladipo');
      expect(team[2].name, 'Oluwabukunmi Rufus');
      expect(team.where((m) => m.isPlaceholder), isEmpty);
    });

    testWidgets('TeamPage shows the organising team', (tester) async {
      tester.view.physicalSize = const Size(1400, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(_testApp(const TeamPage()));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ibim Braide'), findsOneWidget);
      expect(find.text('Organiser'), findsOneWidget);
      expect(find.text('Oluwabukunmi Rufus'), findsOneWidget);
      expect(find.text('Photo coming soon'), findsNothing);
    });
  });
}
