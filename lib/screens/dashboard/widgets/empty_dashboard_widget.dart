import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import 'calling_list_modal.dart';

class EmptyDashboardWidget extends StatelessWidget {
  const EmptyDashboardWidget({super.key});

  Future<void> _launchWebPanel() async {
    final url = Uri.parse('https://app.getcalley.com');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppStyles.roundedLarge,
        border: Border.all(color: AppColors.border, width: 1.2),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        children: [
          // Header Tab: LOAD NUMBER TO CALL
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B), // Deep Slate Navy
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: const Text(
              AppStrings.loadNumberToCall,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Instruction Text with Link
                Text.rich(
                  TextSpan(
                    text: 'Visit ',
                    style: AppStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: GestureDetector(
                          onTap: _launchWebPanel,
                          child: const Text(
                            'https://app.getcalley.com',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const TextSpan(
                        text: ' to upload numbers that you wish to call using Calley Mobile App.',
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Clean Modern Agent Illustration / Phone Graphic
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBlue.withValues(alpha: 0.4),
                    borderRadius: AppStyles.roundedMedium,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background decorative circles
                      Positioned(
                        top: 15,
                        left: 30,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 40,
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),

                      // Center Illustration: Agent with Headset & Phone
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: AppStyles.cardShadow,
                              border: Border.all(color: AppColors.border, width: 2),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.headset_mic_rounded,
                                color: AppColors.primary,
                                size: 42,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: () => CallingListModal.show(context),
                            icon: const Icon(Icons.playlist_add_check_rounded, size: 18),
                            label: const Text('Choose Calling List'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

