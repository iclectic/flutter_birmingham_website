enum TeamRole { organiser, volunteer, contributor }

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.teamRole,
    required this.bio,
    required this.photoAsset,
    this.linkedInUrl,
    this.gitHubUrl,
    this.twitterUrl,
    this.websiteUrl,
  });

  final String id;
  final String name;
  final String role;
  final TeamRole teamRole;
  final String bio;
  final String photoAsset;
  final String? linkedInUrl;
  final String? gitHubUrl;
  final String? twitterUrl;
  final String? websiteUrl;
}
