import '../models/team_member.dart';

/// The Flutter Birmingham organising team.
const List<TeamMember> team = [
  TeamMember(
    id: 'ibim-braide',
    name: 'Ibim Braide',
    role: 'Organiser',
    teamRole: TeamRole.organiser,
    bio: 'Software Engineer | Technical Writer',
    photoAsset: 'assets/images/team/ibim_braide.jpg',
    linkedInUrl: 'https://www.linkedin.com/in/ibim-braide/',
    websiteUrl: 'https://ibimbraide.com/',
    gitHubUrl: 'https://github.com/iclectic',
  ),
  TeamMember(
    id: 'franklin-oladipo',
    name: 'Franklin Oladipo',
    role: 'Co-organiser',
    teamRole: TeamRole.coOrganiser,
    bio: 'Team Lead, Mobile Developer · BT Group',
    photoAsset: 'assets/images/team/franklin_oladipo.jpg',
    linkedInUrl: 'https://www.linkedin.com/in/franklin-oladipo/',
  ),
  TeamMember(
    id: 'oluwabukunmi-rufus',
    name: 'Oluwabukunmi Rufus',
    role: 'Co-organiser',
    teamRole: TeamRole.coOrganiser,
    bio: 'Software Engineer | Power Platform Developer',
    photoAsset: 'assets/images/team/oluwabukunmi_rufus.jpg',
    linkedInUrl: 'https://www.linkedin.com/in/oluwabukunmi-rufus-761015256/',
  ),
];
