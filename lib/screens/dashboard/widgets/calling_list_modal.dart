import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_styles.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/calling_list_provider.dart';

class CallingListModal extends StatelessWidget {
  const CallingListModal({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CallingListModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<CallingListProvider>();
    final user = context.watch<AuthProvider>().currentUser;

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B), // Deep Navy top header background as seen in Figma 07
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle pill
            const SizedBox(height: 10),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 14),

            // Header Title
            const Text(
              AppStrings.callingLists,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 16),

            // Main white content sheet
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Select Calling List + Refresh Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlue.withValues(alpha: 0.5),
                      borderRadius: AppStyles.roundedMedium,
                      border: Border.all(color: AppColors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          AppStrings.selectCallingList,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: listProvider.isLoadingLists
                              ? null
                              : () {
                                  if (user != null) {
                                    listProvider.fetchLists(user.id);
                                  }
                                },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (listProvider.isLoadingLists)
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                else
                                  const Icon(Icons.sync_rounded, color: Colors.white, size: 14),
                                const SizedBox(width: 6),
                                const Text(
                                  AppStrings.refresh,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // List of Calling Lists
                  if (listProvider.isLoadingLists && listProvider.lists.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                    )
                  else if (listProvider.lists.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No calling lists found',
                          style: AppStyles.bodyMedium,
                        ),
                      ),
                    )
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: listProvider.lists.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final list = listProvider.lists[index];
                        final isSelected = listProvider.selectedList?.id == list.id;

                        return Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.surfaceBlue : AppColors.cardBackground,
                            borderRadius: AppStyles.roundedMedium,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              list.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text(
                              '${list.totalCalls} Calls in list',
                              style: AppStyles.bodySmall,
                            ),
                            trailing: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.secondaryBackground,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 16,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                            onTap: () async {
                              await listProvider.selectList(list);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
