import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/local_storage.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/common/calley_logo.dart';
import '../../widgets/inputs/custom_text_field.dart';
import '../dashboard/dashboard_screen.dart';
import '../getting_started/getting_started_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'testing@yopmail.com');
  final _passwordController = TextEditingController(text: '123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final seenWalkthrough = await LocalStorage.hasSeenGettingStarted();
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => seenWalkthrough
              ? const DashboardScreen()
              : const GettingStartedScreen(),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Invalid login credentials'),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const CalleyLogo(size: 52),
                const SizedBox(height: 36),
                Text(
                  AppStrings.welcome,
                  style: AppStyles.h1,
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.signInSubtitle,
                  style: AppStyles.bodyMedium,
                ),
                const SizedBox(height: 36),
                CustomTextField(
                  controller: _emailController,
                  hintText: AppStrings.email,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: Validators.validateEmail,
                ),
                const SizedBox(height: 18),
                CustomTextField(
                  controller: _passwordController,
                  hintText: AppStrings.password,
                  isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline_rounded,
                      color: AppColors.textMuted, size: 20),
                  validator: Validators.validatePassword,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password reset instructions sent to your email'),
                        ),
                      );
                    },
                    child: Text(
                      AppStrings.forgotPassword,
                      style: AppStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.dontHaveAccount,
                      style: AppStyles.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: Text(
                        AppStrings.signUp,
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
                  text: AppStrings.signIn,
                  isLoading: authProvider.isLoading,
                  onPressed: _handleLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
