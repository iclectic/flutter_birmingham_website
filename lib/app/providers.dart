import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content/events.dart';
import '../data/content/team.dart';
import '../data/models/community_event.dart';
import '../data/models/team_member.dart';

/// Source of all events. Override in tests, or swap for a remote source
/// (e.g. a Meetup feed or Firestore) without touching the UI.
final eventsProvider = Provider<List<CommunityEvent>>((_) => events);

final upcomingEventProvider = Provider<CommunityEvent?>(
  (ref) => upcomingEventFrom(ref.watch(eventsProvider)),
);

final pastEventsProvider = Provider<List<CommunityEvent>>(
  (ref) => pastEventsFrom(ref.watch(eventsProvider)),
);

final eventByIdProvider = Provider.family<CommunityEvent?, String>((ref, id) {
  for (final e in ref.watch(eventsProvider)) {
    if (e.id == id) return e;
  }
  return null;
});

final teamProvider = Provider<List<TeamMember>>((_) => team);
