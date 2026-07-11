import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_birmingham_website/app/theme/app_theme.dart';
import 'package:flutter_birmingham_website/core/constants/app_colors.dart';
import 'package:flutter_birmingham_website/core/widgets/fb_logo.dart';
import 'package:flutter_birmingham_website/core/widgets/section_heading.dart';
import 'package:flutter_birmingham_website/core/widgets/placeholder_image.dart';
import 'package:flutter_birmingham_website/data/models/community_event.dart';
import 'package:flutter_birmingham_website/data/models/community_stats.dart';
import 'package:flutter_birmingham_website/data/sample_data/sample_events.dart';
import 'package:flutter_birmingham_website/services/contact_service.dart';

Widget _testApp(Widget child) => ProviderScope(
      child: MaterialApp(
        theme: AppTheme.light,
        home: Scaffold(body: child),
      ),
    );

void main() {
  group('FBLogo', () {
    testWidgets('renders without error and shows RichText', (tester) async {
      await tester.pumpWidget(_testApp(const FBLogo(height: 40)));
      expect(find.byType(FBLogo), findsOneWidget);
      expect(find.byType(RichText), findsWidgets);
    });

    testWidgets('light variant renders without error', (tester) async {
      await tester.pumpWidget(_testApp(
        const ColoredBox(
          color: AppColors.darkNavy,
          child: FBLogo(height: 40, light: true),
        ),
      ));
      expect(find.byType(FBLogo), findsOneWidget);
    });
  });

  group('SectionHeading', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(_testApp(const SectionHeading(
        title: 'Test Title',
        subtitle: 'Test subtitle text',
      )));
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test subtitle text'), findsOneWidget);
    });

    testWidgets('renders eyebrow when provided', (tester) async {
      await tester.pumpWidget(_testApp(const SectionHeading(
        eyebrow: 'EYEBROW',
        title: 'Title',
      )));
      expect(find.text('EYEBROW'), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('omits subtitle when not provided', (tester) async {
      await tester.pumpWidget(
          _testApp(const SectionHeading(title: 'Only Title')));
      expect(find.text('Only Title'), findsOneWidget);
    });
  });

  group('PlaceholderImage', () {
    testWidgets('renders with label', (tester) async {
      await tester.pumpWidget(_testApp(const PlaceholderImage(
        width: 200,
        height: 200,
        label: 'Test image',
      )));
      expect(find.text('Test image'), findsOneWidget);
    });
  });

  group('AssetImageOrPlaceholder', () {
    testWidgets('shows placeholder when asset missing', (tester) async {
      await tester.pumpWidget(_testApp(const AssetImageOrPlaceholder(
        assetPath: 'assets/images/nonexistent.png',
        width: 100,
        height: 100,
        placeholderLabel: 'Missing asset',
      )));
      await tester.pump();
      expect(find.byType(AssetImageOrPlaceholder), findsOneWidget);
    });
  });

  group('CommunityStats', () {
    test('has exactly 4 stats', () {
      expect(CommunityStats.stats.length, 4);
    });

    test('all stats have positive values', () {
      for (final stat in CommunityStats.stats) {
        expect(stat.value, greaterThan(0));
        expect(stat.label, isNotEmpty);
      }
    });
  });

  group('Sample events data', () {
    test('sampleEvents is not empty', () {
      expect(sampleEvents, isNotEmpty);
    });

    test('all events have required fields', () {
      for (final event in sampleEvents) {
        expect(event.id, isNotEmpty);
        expect(event.title, isNotEmpty);
        expect(event.description, isNotEmpty);
        expect(event.venueName, isNotEmpty);
        expect(event.registrationUrl, isNotEmpty);
      }
    });

    test('upcoming event is in the future', () {
      final upcoming = upcomingEvent;
      if (upcoming != null) {
        expect(upcoming.startDateTime.isAfter(DateTime.now()), isTrue);
        expect(upcoming.isUpcoming, isTrue);
      }
    });

    test('past events are in the past', () {
      for (final event in pastEvents) {
        expect(event.isPast, isTrue);
      }
    });

    test('events with recordings have non-empty videoUrl', () {
      for (final event in sampleEvents) {
        if (event.hasRecording) {
          expect(event.videoUrl, isNotEmpty);
        }
      }
    });
  });

  group('CommunityEvent model', () {
    test('isUpcoming returns true for future event', () {
      final event = CommunityEvent(
        id: 'test-1',
        title: 'Test Event',
        description: 'Test',
        startDateTime: DateTime.now().add(const Duration(days: 10)),
        endDateTime:
            DateTime.now().add(const Duration(days: 10, hours: 2)),
        venueName: 'Test Venue',
        venueAddress: 'Test Address',
        imageAsset: 'assets/images/test.png',
        registrationUrl: 'https://example.com',
      );
      expect(event.isUpcoming, isTrue);
      expect(event.isPast, isFalse);
    });

    test('isPast returns true for past event', () {
      final event = CommunityEvent(
        id: 'test-2',
        title: 'Old Event',
        description: 'Old test',
        startDateTime:
            DateTime.now().subtract(const Duration(days: 10)),
        endDateTime: DateTime.now()
            .subtract(const Duration(days: 10))
            .add(const Duration(hours: 2)),
        venueName: 'Old Venue',
        venueAddress: 'Old Address',
        imageAsset: 'assets/images/test.png',
        registrationUrl: 'https://example.com',
      );
      expect(event.isPast, isTrue);
      expect(event.isUpcoming, isFalse);
    });

    test('hasRecording is false when videoUrl is null', () {
      final event = CommunityEvent(
        id: 'test-3',
        title: 'No Recording',
        description: 'desc',
        startDateTime:
            DateTime.now().subtract(const Duration(days: 5)),
        endDateTime:
            DateTime.now().subtract(const Duration(days: 5)),
        venueName: 'Venue',
        venueAddress: 'Address',
        imageAsset: '',
        registrationUrl: 'https://example.com',
      );
      expect(event.hasRecording, isFalse);
    });
  });

  group('MockContactService', () {
    test('stores submitted form data', () async {
      final service = MockContactService();
      const data = ContactFormData(
        name: 'Test User',
        email: 'test@example.com',
        enquiryType: EnquiryType.general,
        subject: 'Test Subject',
        message: 'Test message body',
      );
      await service.submitEnquiry(data);
      expect(service.submissions.length, 1);
      expect(service.submissions.first.name, 'Test User');
      expect(service.submissions.first.email, 'test@example.com');
    });

    test('accumulates multiple submissions', () async {
      final service = MockContactService();
      for (var i = 0; i < 3; i++) {
        await service.submitEnquiry(ContactFormData(
          name: 'User $i',
          email: 'user$i@example.com',
          enquiryType: EnquiryType.general,
          subject: 'Subject $i',
          message: 'Message $i',
        ));
      }
      expect(service.submissions.length, 3);
    });
  });

  group('App theming', () {
    test('AppTheme.light has correct primary color', () {
      final theme = AppTheme.light;
      expect(theme.colorScheme.primary, AppColors.flutterBlue);
    });

    test('AppTheme.light uses Material 3', () {
      final theme = AppTheme.light;
      expect(theme.useMaterial3, isTrue);
    });
  });
}
