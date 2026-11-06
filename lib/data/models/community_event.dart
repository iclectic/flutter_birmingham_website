class CommunityEvent {
  const CommunityEvent({
    required this.id,
    required this.title,
    required this.description,
    required this.startDateTime,
    required this.endDateTime,
    required this.venueName,
    required this.venueAddress,
    required this.imageAsset,
    this.speakers = const [],
    this.topics = const [],
    required this.registrationUrl,
    this.videoUrl,
    this.slidesUrl,
    this.isFeatured = false,
    this.agenda = const [],
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String venueName;
  final String venueAddress;
  final String imageAsset;
  final List<EventSpeaker> speakers;
  final List<String> topics;
  final String registrationUrl;
  final String? videoUrl;
  final String? slidesUrl;
  final bool isFeatured;
  final List<AgendaItem> agenda;

  bool isUpcomingAt([DateTime? now]) =>
      endDateTime.isAfter(now ?? DateTime.now());
  bool get isUpcoming => isUpcomingAt();
  bool get isPast => !isUpcoming;
  bool get hasImage => imageAsset.isNotEmpty;
  bool get hasRecording => videoUrl != null && videoUrl!.isNotEmpty;
  bool get hasSlides => slidesUrl != null && slidesUrl!.isNotEmpty;
}

class EventSpeaker {
  const EventSpeaker({
    required this.id,
    required this.name,
    required this.role,
    required this.company,
    required this.talkTitle,
    required this.talkDescription,
    required this.photoAsset,
    this.linkedInUrl,
    this.gitHubUrl,
    this.twitterUrl,
    this.websiteUrl,
    this.slidesUrl,
    this.videoUrl,
  });

  final String id;
  final String name;
  final String role;
  final String company;
  final String talkTitle;
  final String talkDescription;
  final String photoAsset;
  final String? linkedInUrl;
  final String? gitHubUrl;
  final String? twitterUrl;
  final String? websiteUrl;
  final String? slidesUrl;
  final String? videoUrl;
}

class AgendaItem {
  const AgendaItem({
    required this.time,
    required this.title,
    this.description,
    this.speakerId,
    this.type = AgendaItemType.talk,
  });

  final String time;
  final String title;
  final String? description;
  final String? speakerId;
  final AgendaItemType type;
}

enum AgendaItemType { networking, talk, workshop, lightning, break_, intro }
