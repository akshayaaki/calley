import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case 'called':
      case 'done':
        bg = AppColors.surfaceGreen;
        text = AppColors.success;
        break;
      case 'rescheduled':
      case 'schedule':
        bg = AppColors.surfacePurple;
        text = AppColors.reschedule;
        break;
      case 'pending':
      default:
        bg = AppColors.surfaceOrange;
        text = AppColors.warning;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppStyles.roundedSmall,
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: text,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

