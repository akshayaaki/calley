import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../authentication/login_screen.dart';
import '../../getting_started/getting_started_screen.dart';
import '../../settings/settings_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final username = user?.username ?? 'Swati';
    final email = user?.email ?? 'swati@cstech.in';
    final subscription = user?.subscription ?? 'Calley Personal';

    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: SafeArea(
        child: Column(
          children: [
            // User Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.primary,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: AppColors.primary,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          email,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subscription,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    icon: Icons.rocket_launch_outlined,
                    title: AppStrings.gettingStarted,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const GettingStartedScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.cloud_sync_outlined,
                    title: AppStrings.syncData,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Syncing data with web panel...')),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.grid_view_rounded,
                    title: AppStrings.gamification,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Gamification achievements unlocked!')),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.phone_forwarded_outlined,
                    title: AppStrings.sendLogs,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Call logs submitted to server successfully')),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings_outlined,
                    title: AppStrings.settings,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const SettingsScreen()),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.headset_mic_outlined,
                    title: AppStrings.help,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening Calley Help Center...')),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.person_remove_outlined,
                    title: AppStrings.cancelSubscription,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Manage subscription in web panel')),
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Divider(color: AppColors.border),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Text(
                      AppStrings.appInfo,
                      style: AppStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: Icons.badge_outlined,
                    title: AppStrings.aboutUs,
                    onTap: () {
                      Navigator.pop(context);
                      showAboutDialog(
                        context: context,
                        applicationName: 'Get Calley',
                        applicationVersion: '1.01.52',
                        applicationLegalese: '© 2026 C S Tech Infosolutions Private Limited',
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.verified_user_outlined,
                    title: AppStrings.privacyPolicy,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.article_outlined,
                    title: AppStrings.version,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.share_outlined,
                    title: AppStrings.shareApp,
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing Calley App link...')),
                      );
                    },
                  ),
                  _buildDrawerItem(
                    icon: Icons.logout_rounded,
                    title: AppStrings.logout,
                    textColor: AppColors.error,
                    iconColor: AppColors.error,
                    onTap: () async {
                      Navigator.pop(context);
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
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.textPrimary).withValues(alpha: 0.06),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.textPrimary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      dense: true,
      visualDensity: const VisualDensity(vertical: -1),
      onTap: onTap,
    );
  }
}

