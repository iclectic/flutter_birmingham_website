import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/responsive/breakpoints.dart';
import '../../../core/responsive/responsive_layout.dart';
import '../../../core/widgets/fb_logo.dart';
import '../../../services/url_service.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Breakpoints.isMobile(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.heroGradientStart,
            AppColors.heroGradientMid,
            AppColors.heroGradientEnd,
          ],
          stops: [0.0, 0.55, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Background geometric decoration
          Positioned.fill(child: _HeroBackground()),
          // Content
          ContentContainer(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? AppSpacing.xxl : AppSpacing.xxxl + 16,
              ),
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: isMobile
                      ? _MobileHeroContent()
                      : _DesktopHeroContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHeroContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: _HeroText(),
        ),
        const SizedBox(width: AppSpacing.xxxl),
        Expanded(
          flex: 4,
          child: _HeroIllustration(),
        ),
      ],
    );
  }
}

class _MobileHeroContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _HeroText(),
        const SizedBox(height: AppSpacing.xxl),
        Center(child: _HeroIllustration()),
      ],
    );
  }
}

class _HeroText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Breakpoints.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FBLogo(height: 44, light: true),
        const SizedBox(height: AppSpacing.xl),
        Text(
          AppStrings.appName,
          style: theme.textTheme.displaySmall?.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w800,
            fontSize: isMobile ? 36 : 52,
            height: 1.1,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.appTagline,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.lightBlue,
            fontWeight: FontWeight.w500,
            fontSize: isMobile ? 17 : 20,
            height: 1.4,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.appDescription,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.white.withAlpha(200),
            fontSize: isMobile ? 15 : 16,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            Semantics(
              label: 'View our next event',
              child: ElevatedButton.icon(
                onPressed: () => GoRouter.of(context).go('/events'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightBlue,
                  foregroundColor: AppColors.darkNavy,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                icon: const Icon(Icons.event_outlined, size: 20),
                label: const Text('View Our Next Event'),
              ),
            ),
            Semantics(
              label: 'Become a speaker at Flutter Birmingham',
              child: OutlinedButton.icon(
                onPressed: () => UrlService.open(AppStrings.speakerFormUrl),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.white, width: 1.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                    vertical: AppSpacing.md,
                  ),
                ),
                icon: const Icon(Icons.mic_none_outlined, size: 20),
                label: const Text('Become a Speaker'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroIllustration extends StatefulWidget {
  @override
  State<_HeroIllustration> createState() => _HeroIllustrationState();
}

class _HeroIllustrationState extends State<_HeroIllustration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _float;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
    _float = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reducedMotion = MediaQuery.of(context).disableAnimations;
    return AnimatedBuilder(
      animation: _float,
      builder: (context, child) {
        return Transform.translate(
          offset: reducedMotion ? Offset.zero : Offset(0, _float.value),
          child: child,
        );
      },
      child: _FlutterGeometricArt(),
    );
  }
}

class _FlutterGeometricArt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = Breakpoints.isMobile(context) ? 220.0 : 320.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GeometricArtPainter(),
      ),
    );
  }
}

class _GeometricArtPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Outer glow circle
    final glowPaint = Paint()
      ..color = AppColors.lightBlue.withAlpha(30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawCircle(Offset(w / 2, h / 2), w * 0.46, glowPaint);

    // Large diamond
    final diamondPaint = Paint()
      ..color = AppColors.flutterBlue.withAlpha(200)
      ..style = PaintingStyle.fill;
    final diamond = Path()
      ..moveTo(w * 0.5, h * 0.05)
      ..lineTo(w * 0.95, h * 0.5)
      ..lineTo(w * 0.5, h * 0.95)
      ..lineTo(w * 0.05, h * 0.5)
      ..close();
    canvas.drawPath(diamond, diamondPaint);

    // Inner lighter diamond
    final innerPaint = Paint()
      ..color = AppColors.brightBlue.withAlpha(220)
      ..style = PaintingStyle.fill;
    final inner = Path()
      ..moveTo(w * 0.5, h * 0.22)
      ..lineTo(w * 0.78, h * 0.5)
      ..lineTo(w * 0.5, h * 0.78)
      ..lineTo(w * 0.22, h * 0.5)
      ..close();
    canvas.drawPath(inner, innerPaint);

    // Small accent diamond
    final accentPaint = Paint()
      ..color = AppColors.lightBlue.withAlpha(230)
      ..style = PaintingStyle.fill;
    final accent = Path()
      ..moveTo(w * 0.5, h * 0.36)
      ..lineTo(w * 0.64, h * 0.5)
      ..lineTo(w * 0.5, h * 0.64)
      ..lineTo(w * 0.36, h * 0.5)
      ..close();
    canvas.drawPath(accent, accentPaint);

    // Floating accent dots
    final dotPaint = Paint()..color = AppColors.lightBlue.withAlpha(180);
    canvas.drawCircle(Offset(w * 0.12, h * 0.18), 6, dotPaint);
    canvas.drawCircle(Offset(w * 0.88, h * 0.22), 4, dotPaint);
    canvas.drawCircle(Offset(w * 0.82, h * 0.82), 8, dotPaint);
    canvas.drawCircle(Offset(w * 0.15, h * 0.78), 5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _HeroBackgroundPainter(),
    );
  }
}

class _HeroBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withAlpha(8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Subtle grid lines
    for (double x = 0; x < size.width; x += 80) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Large background circle
    final circlePaint = Paint()
      ..color = AppColors.white.withAlpha(5)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.1),
      size.width * 0.4,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
