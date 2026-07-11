// PLACEHOLDER DATA — Replace with real sponsor information before launch.

import '../models/sponsor.dart';

final List<Sponsor> sampleSponsors = [
  Sponsor(
    id: 'sp-venue-1',
    name: 'Brindleyplace Innovation Hub',
    logoAsset: 'assets/logos/placeholder_sponsor.png',
    websiteUrl: 'https://placeholder.example.com',
    category: SponsorCategory.venue,
    accessibilityDescription: 'Brindleyplace Innovation Hub logo',
    description: 'Our generous venue partner, providing a fantastic space '
        'for Flutter Birmingham events in the heart of Birmingham.',
  ),
  Sponsor(
    id: 'sp-tech-1',
    name: 'TechForward Ltd',
    logoAsset: 'assets/logos/placeholder_sponsor.png',
    websiteUrl: 'https://placeholder.example.com',
    category: SponsorCategory.technology,
    accessibilityDescription: 'TechForward Ltd logo',
    description: 'Technology sponsor supporting our live streaming and '
        'recording equipment.',
  ),
  Sponsor(
    id: 'sp-refresh-1',
    name: 'Axiom Digital',
    logoAsset: 'assets/logos/placeholder_sponsor.png',
    websiteUrl: 'https://placeholder.example.com',
    category: SponsorCategory.refreshments,
    accessibilityDescription: 'Axiom Digital logo',
    description: 'Kindly sponsors the pizza and refreshments that keep '
        'our community going through the talks.',
  ),
  Sponsor(
    id: 'sp-community-1',
    name: 'Flutter Community',
    logoAsset: 'assets/logos/placeholder_sponsor.png',
    websiteUrl: 'https://flutter.dev',
    category: SponsorCategory.community,
    accessibilityDescription: 'Flutter Community logo',
    description: 'Part of the global Flutter community network.',
  ),
];
