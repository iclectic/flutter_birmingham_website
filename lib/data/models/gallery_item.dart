enum GalleryItemType { speaker, audience, networking, workshop, venue, general }

class GalleryItem {
  const GalleryItem({
    required this.id,
    required this.imageAsset,
    required this.caption,
    required this.eventId,
    required this.eventName,
    required this.year,
    required this.type,
    this.photographerCredit,
  });

  final String id;
  final String imageAsset;
  final String caption;
  final String eventId;
  final String eventName;
  final int year;
  final GalleryItemType type;
  final String? photographerCredit;
}
