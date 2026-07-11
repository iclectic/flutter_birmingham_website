import '../models/gallery_item.dart';
import '../sample_data/sample_gallery.dart';

abstract class GalleryRepository {
  Future<List<GalleryItem>> getGalleryItems();
  Future<List<GalleryItem>> getItemsByEvent(String eventId);
  Future<List<GalleryItem>> getItemsByType(GalleryItemType type);
  Future<List<GalleryItem>> getItemsByYear(int year);
}

class LocalGalleryRepository implements GalleryRepository {
  @override
  Future<List<GalleryItem>> getGalleryItems() async => sampleGallery;

  @override
  Future<List<GalleryItem>> getItemsByEvent(String eventId) async =>
      sampleGallery.where((item) => item.eventId == eventId).toList();

  @override
  Future<List<GalleryItem>> getItemsByType(GalleryItemType type) async =>
      sampleGallery.where((item) => item.type == type).toList();

  @override
  Future<List<GalleryItem>> getItemsByYear(int year) async =>
      sampleGallery.where((item) => item.year == year).toList();
}
