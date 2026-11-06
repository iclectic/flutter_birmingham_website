enum TeamRole { organiser, coOrganiser }

class TeamMember {
  const TeamMember({
    required this.id,
    required this.name,
    required this.role,
    required this.teamRole,
    required this.bio,
    this.photoAsset,
    this.linkedInUrl,
    this.gitHubUrl,
    this.websiteUrl,
    this.isPlaceholder = false,
  });

  final String id;
  final String name;
  final String role;
  final TeamRole teamRole;
  final String bio;
  final String? photoAsset;
  final String? linkedInUrl;
  final String? gitHubUrl;
  final String? websiteUrl;

  /// True for an open organiser slot that hasn't been filled yet.
  final bool isPlaceholder;
}
