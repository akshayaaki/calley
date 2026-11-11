import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpInputField({
    super.key,
    this.length = 6,
    required this.onCompleted,
    this.onChanged,
  });

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (value.length > 1) {
        // Handle paste event
        final pasted = value.replaceAll(RegExp(r'\D'), '');
        for (int i = 0; i < widget.length && i < pasted.length; i++) {
          _controllers[i].text = pasted[i];
        }
        if (pasted.length >= widget.length) {
          _focusNodes.last.unfocus();
          widget.onCompleted(_currentOtp);
        } else {
          _focusNodes[pasted.length].requestFocus();
        }
        widget.onChanged?.call(_currentOtp);
        return;
      }

      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }

    final otp = _currentOtp;
    widget.onChanged?.call(otp);
    if (otp.length == widget.length) {
      widget.onCompleted(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        return SizedBox(
          width: 48,
          height: 54,
          child: KeyboardListener(
            focusNode: FocusNode(),
            onKeyEvent: (event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.backspace &&
                  _controllers[index].text.isEmpty &&
                  index > 0) {
                _controllers[index - 1].clear();
                _focusNodes[index - 1].requestFocus();
              }
            },
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(1),
              ],
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                filled: true,
                fillColor: AppColors.cardBackground,
                border: OutlineInputBorder(
                  borderRadius: AppStyles.roundedMedium,
                  borderSide: const BorderSide(color: AppColors.border, width: 1.2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: AppStyles.roundedMedium,
                  borderSide: const BorderSide(color: AppColors.border, width: 1.2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: AppStyles.roundedMedium,
                  borderSide: const BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
              onChanged: (val) => _onDigitChanged(index, val),
            ),
          ),
        );
      }),
    );
  }
}
