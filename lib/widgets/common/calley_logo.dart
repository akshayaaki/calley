import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CalleyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool isDark;

  const CalleyLogo({
    super.key,
    this.size = 56,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showText) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: CalleyRibbonPainter(),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: CalleyRibbonPainter(),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'CALLEY',
          style: TextStyle(
            fontSize: size * 0.44,
            fontWeight: FontWeight.w800,
            letterSpacing: 2.2,
            color: isDark ? Colors.white : AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'AUTOMATIC CALL DIALER',
          style: TextStyle(
            fontSize: (size * 0.17).clamp(9.0, 13.0),
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class CalleyRibbonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.22
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Multi-color sweeping gradient arc
    final rect = Rect.fromLTWH(w * 0.12, h * 0.12, w * 0.76, h * 0.76);
    final gradient = SweepGradient(
      startAngle: 0.0,
      endAngle: math.pi * 2,
      colors: const [
        Color(0xFFFF007A), // Hot Pink / Magenta
        Color(0xFF8B5CF6), // Purple
        Color(0xFF00D2FF), // Cyan
        Color(0xFF00F5A0), // Green
        Color(0xFFFFD600), // Yellow
        Color(0xFFFF5E00), // Orange
        Color(0xFFFF007A), // Loop to Pink
      ],
    );

    paint.shader = gradient.createShader(rect);

    final path = Path();
    // Modern stylized C ribbon
    path.moveTo(w * 0.82, h * 0.28);
    path.cubicTo(
      w * 0.55, h * 0.05,
      w * 0.18, h * 0.22,
      w * 0.18, h * 0.52,
    );
    path.cubicTo(
      w * 0.18, h * 0.82,
      w * 0.52, h * 0.96,
      w * 0.82, h * 0.74,
    );

    canvas.drawPath(path, paint);

    // Inner subtle glow/specular highlight
    final innerPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round
      ..color = Colors.white.withValues(alpha: 0.4);

    final innerPath = Path();
    innerPath.moveTo(w * 0.70, h * 0.26);
    innerPath.cubicTo(
      w * 0.50, h * 0.14,
      w * 0.26, h * 0.28,
      w * 0.26, h * 0.50,
    );
    canvas.drawPath(innerPath, innerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

