import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../authentication/login_screen.dart';
import '../language/language_selection_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final language = context.watch<LanguageProvider>().currentLanguage;

    final username = user?.username ?? 'Swati';
    final email = user?.email ?? 'swati@cstech.in';
    final phone = user?.phone ?? '9971125588';
    final subscription = user?.subscription ?? 'Calley Personal';
    final parentAccount = user?.parentAccount ?? 'NA';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Setting'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Card (Deep Navy background from Figma 07)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Deep Slate Navy
                  borderRadius: AppStyles.roundedLarge,
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(Icons.person_rounded, color: AppColors.primary, size: 32),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello $username',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Divider(color: Colors.white24),
                    const SizedBox(height: 12),
                    _buildProfileInfoRow('Mobile Number', phone),
                    const SizedBox(height: 8),
                    _buildProfileInfoRow('Parent Account', parentAccount),
                    const SizedBox(height: 8),
                    _buildProfileInfoRow('Current Subscription', subscription),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // PROFILE SETTINGS Header
              const Text(
                'PROFILE SETTINGS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),

              // Settings Options
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: AppStyles.roundedLarge,
                  border: Border.all(color: AppColors.border, width: 1),
                  boxShadow: AppStyles.cardShadow,
                ),
                child: Column(
                  children: [
                    _buildSettingTile(
                      icon: Icons.language_rounded,
                      title: 'App Language',
                      subtitle: '${language.name} (${language.greeting})',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LanguageSelectionScreen(isFromSettings: true),
                          ),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 56),
                    _buildSettingTile(
                      icon: Icons.lock_outline_rounded,
                      title: 'Change Password',
                      subtitle: 'Update your security credentials',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Password reset link sent to your email')),
                        );
                      },
                    ),
                    const Divider(color: AppColors.border, height: 1, indent: 56),
                    _buildSettingTile(
                      icon: Icons.logout_rounded,
                      title: 'Logout',
                      subtitle: 'Sign out from this device',
                      textColor: AppColors.error,
                      iconColor: AppColors.error,
                      onTap: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => const LoginScreen()),
                            (route) => false,
                          );
                        }
                      },
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

  Widget _buildProfileInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppStyles.bodySmall,
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }
}

