import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isPhone;
  final String countryCode;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.isPhone = false,
    this.countryCode = '+91',
    this.onChanged,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
        ],
        TextFormField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          readOnly: widget.readOnly,
          maxLines: widget.isPassword ? 1 : widget.maxLines,
          onChanged: widget.onChanged,
          style: AppStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: widget.isPhone
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          '🇮🇳',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.countryCode,
                          style: AppStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 1,
                          height: 20,
                          color: AppColors.border,
                        ),
                      ],
                    ),
                  )
                : widget.prefixIcon,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}

