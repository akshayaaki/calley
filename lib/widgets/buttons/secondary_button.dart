import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Widget? icon;
  final double? width;
  final double height;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.width,
    this.height = 50,
    this.borderColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: borderColor ?? AppColors.border, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.roundedMedium,
          ),
          foregroundColor: textColor ?? AppColors.textPrimary,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: AppStyles.buttonText.copyWith(
                color: textColor ?? AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

