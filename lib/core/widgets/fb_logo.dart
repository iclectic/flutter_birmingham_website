import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Flutter Birmingham logo widget.
/// Replace the placeholder with an actual SVG asset once the logo is designed.
/// To use an SVG: import flutter_svg and use SvgPicture.asset('assets/logos/fb_logo.svg')
class FBLogo extends StatelessWidget {
  const FBLogo({
    super.key,
    this.height = 40,
    this.light = false,
  });

  final double height;
  final bool light;

  @override
  Widget build(BuildContext context) {
    final textColor = light ? AppColors.white : AppColors.darkNavy;
    final accentColor = light ? AppColors.lightBlue : AppColors.flutterBlue;
    final fontSize = height * 0.45;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Flutter "F" diamond mark
        SizedBox(
          width: height,
          height: height,
          child: CustomPaint(
            painter: _FDiamondPainter(color: accentColor),
          ),
        ),
        const SizedBox(width: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Flutter ',
                style: TextStyle(
                  color: accentColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
              TextSpan(
                text: 'Birmingham',
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  fontFamily: 'PlusJakartaSans',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FDiamondPainter extends CustomPainter {
  const _FDiamondPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    // Outer diamond
    final outer = Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.5)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.5)
      ..close();
    canvas.drawPath(outer, paint);

    // Inner "F" cutout in white
    final white = Paint()..color = Colors.white;
    // Top-left notch to create stylised F
    final cutout = Path()
      ..moveTo(w * 0.28, h * 0.38)
      ..lineTo(w * 0.72, h * 0.38)
      ..lineTo(w * 0.72, h * 0.48)
      ..lineTo(w * 0.28, h * 0.48)
      ..close();
    canvas.drawPath(cutout, white);

    final cutout2 = Path()
      ..moveTo(w * 0.28, h * 0.52)
      ..lineTo(w * 0.58, h * 0.52)
      ..lineTo(w * 0.58, h * 0.62)
      ..lineTo(w * 0.28, h * 0.62)
      ..close();
    canvas.drawPath(cutout2, white);
  }

  @override
  bool shouldRepaint(_FDiamondPainter oldDelegate) => oldDelegate.color != color;
}
