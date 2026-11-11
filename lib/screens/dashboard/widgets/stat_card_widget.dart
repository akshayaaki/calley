import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_styles.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final int count;
  final Color accentColor;
  final Color backgroundColor;
  final VoidCallback? onTap;

  const StatCardWidget({
    super.key,
    required this.title,
    required this.count,
    required this.accentColor,
    required this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: AppStyles.roundedMedium,
            border: Border.all(color: AppColors.border.withValues(alpha: 0.6), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Vertical colored accent bar
              Container(
                width: 3.5,
                height: 38,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          count.toString().padLeft(2, '0'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Calls',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

