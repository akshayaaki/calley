import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_styles.dart';
import '../../providers/language_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../authentication/login_screen.dart';

class LanguageSelectionScreen extends StatelessWidget {
  final bool isFromSettings;

  const LanguageSelectionScreen({super.key, this.isFromSettings = false});

  @override
  Widget build(BuildContext context) {
    final languageProvider = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          AppStrings.chooseLanguage,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        leading: isFromSettings
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: AppStyles.roundedLarge,
                    border: Border.all(color: AppColors.border, width: 1),
                    boxShadow: AppStyles.cardShadow,
                  ),
                  child: ClipRRect(
                    borderRadius: AppStyles.roundedLarge,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: languageProvider.languages.length,
                      separatorBuilder: (context, index) => const Divider(
                        color: AppColors.border,
                        height: 1,
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final lang = languageProvider.languages[index];
                        final isSelected = lang.code == languageProvider.selectedLanguageCode;

                        return Material(
                          color: isSelected ? AppColors.surfaceBlue.withValues(alpha: 0.5) : Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              languageProvider.selectLanguage(lang.code);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          lang.name,
                                          style: AppStyles.bodyLarge.copyWith(
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          lang.greeting,
                                          style: AppStyles.bodySmall.copyWith(
                                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? AppColors.primary : AppColors.textMuted,
                                        width: isSelected ? 6.5 : 1.8,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: AppStrings.select,
                onPressed: () {
                  if (isFromSettings) {
                    Navigator.pop(context);
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

