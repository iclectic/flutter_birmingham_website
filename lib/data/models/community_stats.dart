class CommunityStat {
  const CommunityStat({
    required this.value,
    required this.label,
    required this.icon,
    this.suffix = '+',
  });

  final int value;
  final String label;
  final String icon;
  final String suffix;
}

class CommunityStats {
  // Update these values as the community grows
  static const List<CommunityStat> stats = [
    CommunityStat(
      value: 450,
      label: 'Community Members',
      icon: '👥',
      suffix: '+',
    ),
    CommunityStat(
      value: 24,
      label: 'Events Organised',
      icon: '📅',
      suffix: '',
    ),
    CommunityStat(
      value: 60,
      label: 'Speakers Hosted',
      icon: '🎤',
      suffix: '+',
    ),
    CommunityStat(
      value: 80,
      label: 'Talks Recorded',
      icon: '🎬',
      suffix: '+',
    ),
  ];
}
