import '../models/team_member.dart';
import '../sample_data/sample_team.dart';

abstract class TeamRepository {
  Future<List<TeamMember>> getTeamMembers();
  Future<List<TeamMember>> getOrganisers();
  Future<List<TeamMember>> getVolunteers();
}

class LocalTeamRepository implements TeamRepository {
  @override
  Future<List<TeamMember>> getTeamMembers() async => sampleTeam;

  @override
  Future<List<TeamMember>> getOrganisers() async =>
      sampleTeam.where((m) => m.teamRole == TeamRole.organiser).toList();

  @override
  Future<List<TeamMember>> getVolunteers() async =>
      sampleTeam.where((m) => m.teamRole == TeamRole.volunteer).toList();
}
