import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../core/utils/local_storage.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/buttons/whatsapp_button.dart';
import '../dashboard/dashboard_screen.dart';

class GettingStartedScreen extends StatelessWidget {
  const GettingStartedScreen({super.key});

  Future<void> _launchWebPanel(BuildContext context) async {
    final url = Uri.parse('https://app.getcalley.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchVideo(BuildContext context) async {
    final url = Uri.parse('https://www.youtube.com/watch?v=bP4U-L4EHcg');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _onStartCalling(BuildContext context) async {
    await LocalStorage.setSeenGettingStarted(true);
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    final username = user?.username ?? 'Swati';
    final subscription = user?.subscription ?? 'Calley Personal';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // User Profile Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: AppStyles.roundedMedium,
                  boxShadow: AppStyles.buttonShadow,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello $username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subscription,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Web Panel Instruction Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B), // Deep Slate Navy from video
                  borderRadius: AppStyles.roundedLarge,
                ),
                child: Column(
                  children: [
                    Text(
                      'If you are here for the first time then ensure that you have uploaded the list to call from calley Web Panel hosted on',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () => _launchWebPanel(context),
                      child: const Text(
                        'https://app.getcalley.com',
                        style: TextStyle(
                          color: Color(0xFF38BDF8), // Light Cyan / Sky
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // 2 MINUTE CHALLENGE Video Card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: AppStyles.roundedLarge,
                    border: Border.all(color: AppColors.border, width: 1.2),
                    boxShadow: AppStyles.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: AppStyles.roundedLarge,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Soft notebook / sketch texture background
                        Container(
                          color: const Color(0xFFFBFBFD),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    '2 MINUTE',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: Color(0xFF0369A1),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 60),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'CHALLENGE',
                                    style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2,
                                      color: Color(0xFF0369A1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Big Red Play Button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(40),
                            onTap: () => _launchVideo(context),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF0000), // YouTube Red
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withValues(alpha: 0.35),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Bottom Action Bar: WhatsApp + Start Calling Now
              Row(
                children: [
                  const WhatsAppButton(size: 52),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      text: AppStrings.startCallingNow,
                      onPressed: () => _onStartCalling(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

