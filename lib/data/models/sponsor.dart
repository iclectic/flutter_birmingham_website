enum SponsorCategory { community, venue, refreshments, technology, media }

class Sponsor {
  const Sponsor({
    required this.id,
    required this.name,
    required this.logoAsset,
    required this.websiteUrl,
    required this.category,
    required this.accessibilityDescription,
    this.description,
  });

  final String id;
  final String name;
  final String logoAsset;
  final String websiteUrl;
  final SponsorCategory category;
  final String accessibilityDescription;
  final String? description;
}
