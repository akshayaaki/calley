import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/calley_logo.dart';
import '../../widgets/inputs/otp_input_field.dart';
import '../getting_started/getting_started_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String email;
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.email,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  String _enteredOtp = '';

  Future<void> _handleVerify() async {
    if (_enteredOtp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter all 6 digits of the OTP code'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtpAndCompleteLogin(_enteredOtp);

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const GettingStartedScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'OTP verification failed'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Future<void> _handleResend() async {
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.resendOtp();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A new OTP has been dispatched to your email'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to resend OTP'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CalleyLogo(size: 50),
              const SizedBox(height: 32),
              Text(
                AppStrings.whatsappOtpVerification,
                style: AppStyles.h1.copyWith(fontSize: 22),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.otpSubtitle,
                textAlign: TextAlign.center,
                style: AppStyles.bodyMedium,
              ),
              const SizedBox(height: 36),
              OtpInputField(
                length: 6,
                onChanged: (val) {
                  _enteredOtp = val;
                },
                onCompleted: (val) {
                  _enteredOtp = val;
                  _handleVerify();
                },
              ),
              const SizedBox(height: 20),
              Text(
                widget.phoneNumber,
                style: AppStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.didNotReceiveOtp,
                    style: AppStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: authProvider.isLoading ? null : _handleResend,
                    child: Text(
                      AppStrings.resendOtp,
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                text: AppStrings.verify,
                isLoading: authProvider.isLoading,
                onPressed: _handleVerify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

