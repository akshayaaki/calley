import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/calley_logo.dart';
import '../../widgets/inputs/custom_text_field.dart';
import 'login_screen.dart';
import 'otp_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _agreedToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms and Conditions to proceed'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.initiateRegistration(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      phone: _phoneController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            email: _emailController.text.trim(),
            phoneNumber: '+91 ${_phoneController.text.trim()}',
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Registration failed'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const CalleyLogo(size: 50),
                const SizedBox(height: 28),
                Text(
                  AppStrings.welcomeExclamation,
                  style: AppStyles.h1,
                ),
                const SizedBox(height: 6),
                Text(
                  AppStrings.registerSubtitle,
                  style: AppStyles.bodyMedium,
                ),
                const SizedBox(height: 28),
                CustomTextField(
                  controller: _nameController,
                  hintText: AppStrings.name,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: Validators.validateName,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _emailController,
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  hintText: AppStrings.password,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _phoneController,
                  hintText: AppStrings.mobileNumber,
                  isPhone: true,
                  keyboardType: TextInputType.phone,
                  validator: Validators.validatePhone,
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreedToTerms,
                        activeColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: const BorderSide(color: AppColors.border, width: 1.5),
                        onChanged: (val) {
                          setState(() {
                            _agreedToTerms = val ?? false;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _agreedToTerms = !_agreedToTerms;
                          });
                        },
                        child: Text.rich(
                          TextSpan(
                            text: 'I agree to the ',
                            style: AppStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            children: const [
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                PrimaryButton(
                  text: AppStrings.signUp,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleRegister,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount,
                      style: AppStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        AppStrings.signIn,
                        style: AppStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

