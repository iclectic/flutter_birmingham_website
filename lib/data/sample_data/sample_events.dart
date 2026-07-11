// PLACEHOLDER DATA — Replace with real event information before launch.
// All names, dates, venues, and details below are fictional examples.

import '../models/community_event.dart';

final List<CommunityEvent> sampleEvents = [
  // ─── UPCOMING EVENT ──────────────────────────────────────────────────────
  CommunityEvent(
    id: 'fb-025',
    title: 'Flutter Birmingham #25',
    description:
        'Join us for our 25th meetup! We have two fantastic talks lined up '
        'covering Flutter 3.x rendering architecture and building production-ready '
        'AI features with the Google AI Dart SDK. Plus the usual networking, '
        'pizza, and great conversation.',
    startDateTime: DateTime(2026, 9, 17, 18, 30),
    endDateTime: DateTime(2026, 9, 17, 21, 0),
    venueName: 'Brindleyplace Innovation Hub',
    venueAddress: '1 Brunswick Square, Brindleyplace, Birmingham, B1 2HW',
    imageAsset: 'assets/images/events/event_placeholder.png',
    speakers: [
      EventSpeaker(
        id: 'sp-alice',
        name: 'Alice Fontaine',
        role: 'Senior Flutter Engineer',
        company: 'TechForward Ltd',
        talkTitle: 'Deep Dive into Flutter\'s Rendering Pipeline',
        talkDescription:
            'A comprehensive exploration of how Flutter renders widgets, '
            'how to diagnose jank, and practical optimisation strategies '
            'for smooth 120fps experiences.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        linkedInUrl: 'https://www.linkedin.com/in/placeholder',
        gitHubUrl: 'https://github.com/placeholder',
      ),
      EventSpeaker(
        id: 'sp-marcus',
        name: 'Marcus Obi',
        role: 'Developer Advocate',
        company: 'Dart & Flutter Team',
        talkTitle: 'Building AI-Powered Flutter Apps with Gemini',
        talkDescription:
            'Hands-on walkthrough of the google_generative_ai package, '
            'prompt engineering patterns, streaming responses, '
            'and how to build responsible AI features into your Flutter app.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        linkedInUrl: 'https://www.linkedin.com/in/placeholder',
        gitHubUrl: 'https://github.com/placeholder',
      ),
    ],
    topics: ['Rendering', 'Performance', 'AI', 'Gemini', 'Flutter 3.x'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    isFeatured: true,
    agenda: [
      AgendaItem(
        time: '18:30',
        title: 'Doors open & networking',
        type: AgendaItemType.networking,
      ),
      AgendaItem(
        time: '19:00',
        title: 'Welcome & community announcements',
        type: AgendaItemType.intro,
      ),
      AgendaItem(
        time: '19:10',
        title: 'Deep Dive into Flutter\'s Rendering Pipeline',
        description: '40-minute talk + Q&A',
        speakerId: 'sp-alice',
        type: AgendaItemType.talk,
      ),
      AgendaItem(
        time: '19:55',
        title: 'Break & refreshments',
        type: AgendaItemType.break_,
      ),
      AgendaItem(
        time: '20:10',
        title: 'Building AI-Powered Flutter Apps with Gemini',
        description: '40-minute talk + Q&A',
        speakerId: 'sp-marcus',
        type: AgendaItemType.talk,
      ),
      AgendaItem(
        time: '20:55',
        title: 'Networking & close',
        type: AgendaItemType.networking,
      ),
    ],
  ),

  // ─── PAST EVENTS ─────────────────────────────────────────────────────────
  CommunityEvent(
    id: 'fb-024',
    title: 'Flutter Birmingham #24 — State Management Special',
    description:
        'An evening dedicated to Flutter state management. We covered Riverpod '
        '2.x patterns, comparing BLoC vs Riverpod for large-scale apps, '
        'and a live refactoring demo.',
    startDateTime: DateTime(2026, 7, 16, 18, 30),
    endDateTime: DateTime(2026, 7, 16, 21, 0),
    venueName: 'Innovation Birmingham',
    venueAddress: 'Faraday Wharf, Holt Street, Birmingham, B7 4BB',
    imageAsset: 'assets/images/events/event_placeholder.png',
    speakers: [
      EventSpeaker(
        id: 'sp-priya',
        name: 'Priya Sharma',
        role: 'Mobile Lead',
        company: 'Axiom Digital',
        talkTitle: 'Riverpod 2.x in Production: Lessons Learned',
        talkDescription:
            'A frank account of migrating a large Flutter codebase to '
            'Riverpod 2.x, including pitfalls, testing strategies, '
            'and how to structure providers at scale.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        linkedInUrl: 'https://www.linkedin.com/in/placeholder',
        videoUrl: 'https://www.youtube.com/watch?v=placeholder-1',
        slidesUrl: 'https://speakerdeck.com/placeholder',
      ),
    ],
    topics: ['State Management', 'Riverpod', 'Architecture'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    videoUrl: 'https://www.youtube.com/watch?v=placeholder-1',
    slidesUrl: 'https://speakerdeck.com/placeholder',
    isFeatured: false,
  ),
  CommunityEvent(
    id: 'fb-023',
    title: 'Flutter Birmingham #23 — Testing & Accessibility',
    description:
        'A deep dive into testing Flutter applications and making them '
        'accessible to all users. Covered widget tests, golden tests, '
        'integration tests, and how to meet WCAG 2.1 AA standards in Flutter.',
    startDateTime: DateTime(2026, 5, 21, 18, 30),
    endDateTime: DateTime(2026, 5, 21, 21, 0),
    venueName: 'WeWork Colmore Row',
    venueAddress: '55 Colmore Row, Birmingham, B3 2AA',
    imageAsset: 'assets/images/events/event_placeholder.png',
    speakers: [
      EventSpeaker(
        id: 'sp-joel',
        name: 'Joel Fernandez',
        role: 'QA & Accessibility Engineer',
        company: 'Bespoke Apps Ltd',
        talkTitle: 'Accessible Flutter: Meeting WCAG 2.1 in Practice',
        talkDescription:
            'Practical techniques for building Flutter apps that work for '
            'users with visual, motor, and cognitive disabilities. Includes '
            'Semantics widgets, TalkBack/VoiceOver testing, and colour contrast tools.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        gitHubUrl: 'https://github.com/placeholder',
        videoUrl: 'https://www.youtube.com/watch?v=placeholder-2',
      ),
    ],
    topics: ['Testing', 'Accessibility', 'WCAG', 'Widget Tests'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    videoUrl: 'https://www.youtube.com/watch?v=placeholder-2',
    isFeatured: false,
  ),
  CommunityEvent(
    id: 'fb-022',
    title: 'Flutter Birmingham #22 — Dart 3 & Beyond',
    description:
        'Exploring the headline features of Dart 3: sealed classes, '
        'patterns and pattern matching, records, and the new switch expressions. '
        'A hands-on evening with live coding exercises.',
    startDateTime: DateTime(2026, 3, 18, 18, 30),
    endDateTime: DateTime(2026, 3, 18, 21, 0),
    venueName: 'Brindleyplace Innovation Hub',
    venueAddress: '1 Brunswick Square, Brindleyplace, Birmingham, B1 2HW',
    imageAsset: 'assets/images/events/event_placeholder.png',
    speakers: [
      EventSpeaker(
        id: 'sp-elena',
        name: 'Elena Kovac',
        role: 'Dart SDK Engineer',
        company: 'Google',
        talkTitle: 'Pattern Matching & Records in Dart 3',
        talkDescription:
            'A guided tour of Dart 3\'s most powerful new language features, '
            'with real-world examples and live coding to show you how to '
            'write more expressive, safer Dart code today.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        linkedInUrl: 'https://www.linkedin.com/in/placeholder',
        videoUrl: 'https://www.youtube.com/watch?v=placeholder-3',
        slidesUrl: 'https://speakerdeck.com/placeholder',
      ),
    ],
    topics: ['Dart 3', 'Language Features', 'Patterns', 'Records'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    videoUrl: 'https://www.youtube.com/watch?v=placeholder-3',
    slidesUrl: 'https://speakerdeck.com/placeholder',
    isFeatured: true,
  ),
  CommunityEvent(
    id: 'fb-021',
    title: 'Flutter Birmingham #21 — Flutter for Web',
    description:
        'A focused evening on Flutter Web development: routing, SEO, '
        'responsive layouts, progressive web app configuration, '
        'and how to deploy to Firebase Hosting.',
    startDateTime: DateTime(2026, 1, 22, 18, 30),
    endDateTime: DateTime(2026, 1, 22, 21, 0),
    venueName: 'Innovation Birmingham',
    venueAddress: 'Faraday Wharf, Holt Street, Birmingham, B7 4BB',
    imageAsset: 'assets/images/events/event_placeholder.png',
    speakers: [
      EventSpeaker(
        id: 'sp-rajan',
        name: 'Rajan Patel',
        role: 'Full-Stack Flutter Developer',
        company: 'Orion Tech',
        talkTitle: 'Production Flutter Web: SEO, Routing & Deployment',
        talkDescription:
            'Everything you need to know about shipping a Flutter Web app '
            'to production, including go_router setup, meta tags, '
            'rendering modes, and Firebase Hosting configuration.',
        photoAsset: 'assets/images/team/placeholder_speaker.png',
        linkedInUrl: 'https://www.linkedin.com/in/placeholder',
        videoUrl: 'https://www.youtube.com/watch?v=placeholder-4',
      ),
    ],
    topics: ['Flutter Web', 'go_router', 'SEO', 'Firebase', 'Deployment'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    videoUrl: 'https://www.youtube.com/watch?v=placeholder-4',
    isFeatured: false,
  ),
];

CommunityEvent? get upcomingEvent =>
    sampleEvents.where((e) => e.isUpcoming).isNotEmpty
        ? sampleEvents.where((e) => e.isUpcoming).first
        : null;

List<CommunityEvent> get pastEvents =>
    sampleEvents.where((e) => e.isPast).toList()
      ..sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
