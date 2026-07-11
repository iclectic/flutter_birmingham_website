import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/community_event.dart';
import '../data/models/gallery_item.dart';
import '../data/models/sponsor.dart';
import '../data/models/team_member.dart';
import '../data/repositories/events_repository.dart';
import '../data/repositories/gallery_repository.dart';
import '../data/repositories/team_repository.dart';
import '../data/sample_data/sample_sponsors.dart';
import '../services/contact_service.dart';

// ─── Repository providers ─────────────────────────────────────────────────

final eventsRepositoryProvider = Provider<EventsRepository>(
  (_) => LocalEventsRepository(),
);

final teamRepositoryProvider = Provider<TeamRepository>(
  (_) => LocalTeamRepository(),
);

final galleryRepositoryProvider = Provider<GalleryRepository>(
  (_) => LocalGalleryRepository(),
);

final contactServiceProvider = Provider<ContactService>(
  (_) => MockContactService(),
);

// ─── Data providers ────────────────────────────────────────────────────────

final allEventsProvider = FutureProvider<List<CommunityEvent>>((ref) async {
  return ref.watch(eventsRepositoryProvider).getEvents();
});

final upcomingEventProvider = FutureProvider<CommunityEvent?>((ref) async {
  return ref.watch(eventsRepositoryProvider).getUpcomingEvent();
});

final pastEventsProvider = FutureProvider<List<CommunityEvent>>((ref) async {
  return ref.watch(eventsRepositoryProvider).getPastEvents();
});

final eventByIdProvider =
    FutureProvider.family<CommunityEvent?, String>((ref, id) async {
  return ref.watch(eventsRepositoryProvider).getEventById(id);
});

final teamMembersProvider = FutureProvider<List<TeamMember>>((ref) async {
  return ref.watch(teamRepositoryProvider).getTeamMembers();
});

final organisersProvider = FutureProvider<List<TeamMember>>((ref) async {
  return ref.watch(teamRepositoryProvider).getOrganisers();
});

final volunteersProvider = FutureProvider<List<TeamMember>>((ref) async {
  return ref.watch(teamRepositoryProvider).getVolunteers();
});

final galleryItemsProvider = FutureProvider<List<GalleryItem>>((ref) async {
  return ref.watch(galleryRepositoryProvider).getGalleryItems();
});

final sponsorsProvider = Provider<List<Sponsor>>((_) => sampleSponsors);

// ─── Events filter state ──────────────────────────────────────────────────

class EventsFilterState {
  const EventsFilterState({
    this.searchQuery = '',
    this.selectedYear,
    this.selectedTopic,
    this.selectedSpeaker,
  });

  final String searchQuery;
  final int? selectedYear;
  final String? selectedTopic;
  final String? selectedSpeaker;

  EventsFilterState copyWith({
    String? searchQuery,
    int? selectedYear,
    String? selectedTopic,
    String? selectedSpeaker,
    bool clearYear = false,
    bool clearTopic = false,
    bool clearSpeaker = false,
  }) {
    return EventsFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedYear: clearYear ? null : (selectedYear ?? this.selectedYear),
      selectedTopic: clearTopic ? null : (selectedTopic ?? this.selectedTopic),
      selectedSpeaker: clearSpeaker ? null : (selectedSpeaker ?? this.selectedSpeaker),
    );
  }
}

class EventsFilterNotifier extends StateNotifier<EventsFilterState> {
  EventsFilterNotifier() : super(const EventsFilterState());

  void setSearch(String query) => state = state.copyWith(searchQuery: query);
  void setYear(int? year) => state = state.copyWith(
        selectedYear: year,
        clearYear: year == null,
      );
  void setTopic(String? topic) => state = state.copyWith(
        selectedTopic: topic,
        clearTopic: topic == null,
      );
  void setSpeaker(String? speaker) => state = state.copyWith(
        selectedSpeaker: speaker,
        clearSpeaker: speaker == null,
      );
  void clearFilters() => state = const EventsFilterState();
}

final eventsFilterProvider =
    StateNotifierProvider<EventsFilterNotifier, EventsFilterState>(
  (_) => EventsFilterNotifier(),
);

final filteredPastEventsProvider = Provider<AsyncValue<List<CommunityEvent>>>((ref) {
  final filter = ref.watch(eventsFilterProvider);
  final eventsAsync = ref.watch(pastEventsProvider);

  return eventsAsync.whenData((events) {
    var result = events;

    if (filter.searchQuery.isNotEmpty) {
      final q = filter.searchQuery.toLowerCase();
      result = result
          .where((e) =>
              e.title.toLowerCase().contains(q) ||
              e.description.toLowerCase().contains(q) ||
              e.speakers.any((s) => s.name.toLowerCase().contains(q)) ||
              e.topics.any((t) => t.toLowerCase().contains(q)))
          .toList();
    }

    if (filter.selectedYear != null) {
      result = result
          .where((e) => e.startDateTime.year == filter.selectedYear)
          .toList();
    }

    if (filter.selectedTopic != null) {
      result = result
          .where((e) => e.topics.contains(filter.selectedTopic))
          .toList();
    }

    if (filter.selectedSpeaker != null) {
      result = result
          .where((e) =>
              e.speakers.any((s) => s.name == filter.selectedSpeaker))
          .toList();
    }

    return result;
  });
});

// ─── Gallery filter state ─────────────────────────────────────────────────

class GalleryFilterState {
  const GalleryFilterState({
    this.selectedEventId,
    this.selectedYear,
    this.selectedType,
  });

  final String? selectedEventId;
  final int? selectedYear;
  final GalleryItemType? selectedType;

  GalleryFilterState copyWith({
    String? selectedEventId,
    int? selectedYear,
    GalleryItemType? selectedType,
    bool clearEvent = false,
    bool clearYear = false,
    bool clearType = false,
  }) {
    return GalleryFilterState(
      selectedEventId: clearEvent ? null : (selectedEventId ?? this.selectedEventId),
      selectedYear: clearYear ? null : (selectedYear ?? this.selectedYear),
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
    );
  }
}

class GalleryFilterNotifier extends StateNotifier<GalleryFilterState> {
  GalleryFilterNotifier() : super(const GalleryFilterState());

  void setEvent(String? eventId) =>
      state = state.copyWith(selectedEventId: eventId, clearEvent: eventId == null);
  void setYear(int? year) =>
      state = state.copyWith(selectedYear: year, clearYear: year == null);
  void setType(GalleryItemType? type) =>
      state = state.copyWith(selectedType: type, clearType: type == null);
  void clearFilters() => state = const GalleryFilterState();
}

final galleryFilterProvider =
    StateNotifierProvider<GalleryFilterNotifier, GalleryFilterState>(
  (_) => GalleryFilterNotifier(),
);

final filteredGalleryProvider = Provider<AsyncValue<List<GalleryItem>>>((ref) {
  final filter = ref.watch(galleryFilterProvider);
  final galleryAsync = ref.watch(galleryItemsProvider);

  return galleryAsync.whenData((items) {
    var result = items;
    if (filter.selectedEventId != null) {
      result = result.where((i) => i.eventId == filter.selectedEventId).toList();
    }
    if (filter.selectedYear != null) {
      result = result.where((i) => i.year == filter.selectedYear).toList();
    }
    if (filter.selectedType != null) {
      result = result.where((i) => i.type == filter.selectedType).toList();
    }
    return result;
  });
});
