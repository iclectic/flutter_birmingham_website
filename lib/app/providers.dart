import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/content/team.dart';
import '../data/models/team_member.dart';

final teamProvider = Provider<List<TeamMember>>((_) => team);
