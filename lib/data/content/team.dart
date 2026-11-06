import '../models/team_member.dart';

/// The Flutter Birmingham organising team.
/// Co-organiser slots render as placeholders until real profiles are added.
const List<TeamMember> team = [
  TeamMember(
    id: 'ibim-braide',
    name: 'Ibim Braide',
    role: 'Organiser',
    teamRole: TeamRole.organiser,
    bio:
        'Founder of Flutter Birmingham. Brings the Midlands Flutter and Dart '
        'community together to learn, build and share.',
    photoAsset: 'assets/images/team/ibim_braide.jpg',
    websiteUrl: 'https://ibimbraide.com/',
    gitHubUrl: 'https://github.com/iclectic',
  ),
  TeamMember(
    id: 'co-organiser-1',
    name: 'Co-organiser',
    role: 'Co-organiser',
    teamRole: TeamRole.coOrganiser,
    bio: 'Profile coming soon.',
    isPlaceholder: true,
  ),
  TeamMember(
    id: 'co-organiser-2',
    name: 'Co-organiser',
    role: 'Co-organiser',
    teamRole: TeamRole.coOrganiser,
    bio: 'Profile coming soon.',
    isPlaceholder: true,
  ),
];
