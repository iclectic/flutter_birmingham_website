import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../data/models/community_stats.dart';

class StatsSection extends StatelessWidget {
  const StatsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);
    return Container(
      color: AppColors.white,
      child: ContentContainer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? AppSpacing.sectionMobile : AppSpacing.section,
          ),
          child: Column(
            children: [
              ResponsiveGrid(
                mobileColumns: 2,
                tabletColumns: 2,
                desktopColumns: 4,
                spacing: 24,
                runSpacing: 24,
                children: CommunityStats.stats
                    .map((stat) => _StatCard(stat: stat))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatefulWidget {
  const _StatCard({required this.stat});
  final CommunityStat stat;

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _countAnim;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _countAnim = Tween<double>(begin: 0, end: widget.stat.value.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (_started) return;
    _started = true;
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    if (reducedMotion) {
      _controller.value = 1.0;
    } else {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return VisibilityDetector(
      key: Key('stat-${widget.stat.label}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3) _startAnimation();
      },
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          border: Border.all(color: AppColors.cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.stat.icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedBuilder(
              animation: _countAnim,
              builder: (context, _) {
                final value = _countAnim.value.round();
                return Text(
                  '$value${widget.stat.suffix}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.flutterBlue,
                    fontWeight: FontWeight.w800,
                    fontSize: 40,
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              widget.stat.label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.neutralGrey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
