import '../models/community_event.dart';

/// All Flutter Birmingham events, newest first.
/// Add a new [CommunityEvent] here for every meetup; past events move to the
/// "Past events" list automatically once their start time has passed.
/// TODO(organisers): replace the placeholder launch event with real details.
final List<CommunityEvent> events = [
  CommunityEvent(
    id: 'launch-meetup',
    title: 'Flutter Birmingham: Launch Meetup',
    description:
        'The first Flutter Birmingham meetup. Meet other Flutter and Dart '
        'developers from across the West Midlands, hear what\'s new in '
        'Flutter, and help shape what this community becomes. Talks, pizza '
        'and plenty of time to chat. Everyone is welcome, from curious '
        'beginners to seasoned Flutter engineers.',
    startDateTime: DateTime(2027, 1, 28, 18, 30),
    endDateTime: DateTime(2027, 1, 28, 21, 0),
    venueName: 'Venue to be announced',
    venueAddress: 'Birmingham city centre',
    imageAsset: '',
    topics: const ['Flutter', 'Dart', 'Community'],
    registrationUrl: 'https://www.meetup.com/flutter-birmingham/',
    isFeatured: true,
    agenda: const [
      AgendaItem(
        time: '18:30',
        title: 'Doors open, food & networking',
        type: AgendaItemType.networking,
      ),
      AgendaItem(
        time: '19:00',
        title: 'Welcome to Flutter Birmingham',
        type: AgendaItemType.intro,
      ),
      AgendaItem(
        time: '19:15',
        title: 'Talk: speaker to be announced',
        type: AgendaItemType.talk,
      ),
      AgendaItem(
        time: '20:00',
        title: 'Lightning talks & open floor',
        type: AgendaItemType.lightning,
      ),
      AgendaItem(
        time: '20:30',
        title: 'Networking',
        type: AgendaItemType.networking,
      ),
    ],
  ),
];

CommunityEvent? upcomingEventFrom(List<CommunityEvent> all, {DateTime? now}) {
  final upcoming = all.where((e) => e.isUpcomingAt(now)).toList()
    ..sort((a, b) => a.startDateTime.compareTo(b.startDateTime));
  return upcoming.isEmpty ? null : upcoming.first;
}

List<CommunityEvent> pastEventsFrom(
  List<CommunityEvent> all, {
  DateTime? now,
}) =>
    all.where((e) => !e.isUpcomingAt(now)).toList()
      ..sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
