import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class DonutChartWidget extends StatefulWidget {
  final int pending;
  final int called;
  final int rescheduled;
  final double size;

  const DonutChartWidget({
    super.key,
    required this.pending,
    required this.called,
    required this.rescheduled,
    this.size = 210,
  });

  @override
  State<DonutChartWidget> createState() => _DonutChartWidgetState();
}

class _DonutChartWidgetState extends State<DonutChartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant DonutChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pending != widget.pending ||
        oldWidget.called != widget.called ||
        oldWidget.rescheduled != widget.rescheduled) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.pending + widget.called + widget.rescheduled;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: DonutChartPainter(
              pending: widget.pending,
              called: widget.called,
              rescheduled: widget.rescheduled,
              total: total > 0 ? total : 1,
              progress: _animation.value,
            ),
          ),
        );
      },
    );
  }
}

class DonutChartPainter extends CustomPainter {
  final int pending;
  final int called;
  final int rescheduled;
  final int total;
  final double progress;

  DonutChartPainter({
    required this.pending,
    required this.called,
    required this.rescheduled,
    required this.total,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2;
    final strokeWidth = size.width * 0.24;
    final radius = outerRadius - strokeWidth / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    // If total is 0 or empty, draw subtle gray track
    if (pending == 0 && called == 0 && rescheduled == 0) {
      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppColors.border;
      canvas.drawCircle(center, radius, trackPaint);
      return;
    }

    final double pendingAngle = (pending / total) * 2 * math.pi * progress;
    final double calledAngle = (called / total) * 2 * math.pi * progress;
    final double rescheduledAngle = (rescheduled / total) * 2 * math.pi * progress;

    const double gap = 0.05; // Gap between segments in radians

    double startAngle = -math.pi / 2; // Start from top

    // 1. Called / Done Segment (Blue)
    if (called > 0) {
      final calledPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppColors.chartCalled
        ..strokeCap = StrokeCap.butt;
      final sweep = (calledAngle - gap).clamp(0.0, 2 * math.pi);
      canvas.drawArc(rect, startAngle + gap / 2, sweep, false, calledPaint);
      startAngle += calledAngle;
    }

    // 2. Rescheduled / Schedule Segment (Purple)
    if (rescheduled > 0) {
      final reschedPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppColors.chartRescheduled
        ..strokeCap = StrokeCap.butt;
      final sweep = (rescheduledAngle - gap).clamp(0.0, 2 * math.pi);
      canvas.drawArc(rect, startAngle + gap / 2, sweep, false, reschedPaint);
      startAngle += rescheduledAngle;
    }

    // 3. Pending Segment (Orange / Yellow)
    if (pending > 0) {
      final pendingPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..color = AppColors.chartPending
        ..strokeCap = StrokeCap.butt;
      final sweep = (pendingAngle - gap).clamp(0.0, 2 * math.pi);
      canvas.drawArc(rect, startAngle + gap / 2, sweep, false, pendingPaint);
    }
  }

  @override
  bool shouldRepaint(covariant DonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pending != pending ||
        oldDelegate.called != called ||
        oldDelegate.rescheduled != rescheduled;
  }
}

