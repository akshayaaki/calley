import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/local_storage.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/calley_logo.dart';
import '../language/language_selection_screen.dart';
import '../authentication/login_screen.dart';
import '../dashboard/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutBack),
    );

    _animController.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final authProvider = context.read<AuthProvider>();
    final savedLanguage = await LocalStorage.getLanguage();

    Widget target;
    if (savedLanguage == null) {
      target = const LanguageSelectionScreen();
    } else if (authProvider.isAuthenticated) {
      target = const DashboardScreen();
    } else {
      target = const LoginScreen();
    }

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, anim, secAnim) => target,
        transitionsBuilder: (context, animation, secAnim, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _animController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: const CalleyLogo(size: 80),
              ),
            );
          },
        ),
      ),
    );
  }
}
