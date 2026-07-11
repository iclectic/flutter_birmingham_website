// PLACEHOLDER DATA — Replace with real organiser profiles before launch.

import '../models/team_member.dart';

final List<TeamMember> sampleTeam = [
  // ─── ORGANISERS ───────────────────────────────────────────────────────────
  TeamMember(
    id: 'tm-sarah',
    name: 'Sarah Mitchell',
    role: 'Lead Organiser',
    teamRole: TeamRole.organiser,
    bio:
        'Sarah is a senior Flutter engineer with over six years of experience '
        'building cross-platform applications. She founded Flutter Birmingham '
        'to create a welcoming space for Midlands developers to share knowledge '
        'and grow together.',
    photoAsset: 'assets/images/team/placeholder_organiser.png',
    linkedInUrl: 'https://www.linkedin.com/in/placeholder',
    gitHubUrl: 'https://github.com/placeholder',
    websiteUrl: 'https://placeholder.dev',
  ),
  TeamMember(
    id: 'tm-dev',
    name: 'Dev Okonkwo',
    role: 'Co-Organiser & Speaker Coordinator',
    teamRole: TeamRole.organiser,
    bio:
        'Dev is a mobile developer and tech educator passionate about making '
        'Flutter accessible to developers at every experience level. He coordinates '
        'our speaker programme and helps new speakers prepare their first talks.',
    photoAsset: 'assets/images/team/placeholder_organiser.png',
    linkedInUrl: 'https://www.linkedin.com/in/placeholder',
    gitHubUrl: 'https://github.com/placeholder',
  ),
  TeamMember(
    id: 'tm-amara',
    name: 'Amara Diallo',
    role: 'Community & Partnerships Manager',
    teamRole: TeamRole.organiser,
    bio:
        'Amara manages our sponsor relationships, venue partnerships, and community '
        'outreach. She is committed to building a diverse and inclusive community '
        'where everyone feels welcome and valued.',
    photoAsset: 'assets/images/team/placeholder_organiser.png',
    linkedInUrl: 'https://www.linkedin.com/in/placeholder',
    twitterUrl: 'https://twitter.com/placeholder',
  ),

  // ─── VOLUNTEERS ───────────────────────────────────────────────────────────
  TeamMember(
    id: 'tm-oliver',
    name: 'Oliver Barnes',
    role: 'Event Volunteer',
    teamRole: TeamRole.volunteer,
    bio:
        'Oliver helps run our events, from setup to close. A Flutter student '
        'by day, he brings energy and enthusiasm to every meetup.',
    photoAsset: 'assets/images/team/placeholder_volunteer.png',
    gitHubUrl: 'https://github.com/placeholder',
  ),
  TeamMember(
    id: 'tm-nadia',
    name: 'Nadia Hassan',
    role: 'Social Media & Content Volunteer',
    teamRole: TeamRole.volunteer,
    bio:
        'Nadia manages our social media channels and helps create content '
        'that keeps the community connected between events.',
    photoAsset: 'assets/images/team/placeholder_volunteer.png',
    linkedInUrl: 'https://www.linkedin.com/in/placeholder',
    twitterUrl: 'https://twitter.com/placeholder',
  ),
];
