import '../models/community_event.dart';
import '../sample_data/sample_events.dart';

abstract class EventsRepository {
  Future<List<CommunityEvent>> getEvents();
  Future<CommunityEvent?> getEventById(String id);
  Future<CommunityEvent?> getUpcomingEvent();
  Future<List<CommunityEvent>> getPastEvents();
}

class LocalEventsRepository implements EventsRepository {
  @override
  Future<List<CommunityEvent>> getEvents() async => sampleEvents;

  @override
  Future<CommunityEvent?> getEventById(String id) async =>
      sampleEvents.cast<CommunityEvent?>().firstWhere(
            (e) => e?.id == id,
            orElse: () => null,
          );

  @override
  Future<CommunityEvent?> getUpcomingEvent() async => upcomingEvent;

  @override
  Future<List<CommunityEvent>> getPastEvents() async => pastEvents;
}
