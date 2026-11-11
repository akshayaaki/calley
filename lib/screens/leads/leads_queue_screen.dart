import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/call_lead_model.dart';
import '../../providers/calling_list_provider.dart';
import '../../widgets/common/status_badge.dart';
import 'call_feedback_dialog.dart';

class LeadsQueueScreen extends StatelessWidget {
  const LeadsQueueScreen({super.key});

  Future<void> _makePhoneCall(BuildContext context, String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Simulating call to $phoneNumber')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Simulating call to $phoneNumber')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<CallingListProvider>();
    final details = listProvider.listDetails;
    final lead = listProvider.currentLead;
    final totalCalls = details?.calls.length ?? 0;
    final currentIndex = listProvider.activeLeadIndex;

    return Scaffold(
      backgroundColor: AppColors.secondaryBackground,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            Text(
              listProvider.selectedList?.name ?? 'Calling Queue',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            if (totalCalls > 0)
              Text(
                'Lead ${currentIndex + 1} of $totalCalls',
                style: AppStyles.caption,
              ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            onPressed: () => _showAllLeadsBottomSheet(context, details?.calls ?? []),
          ),
        ],
      ),
      body: lead == null
          ? const Center(child: Text('No leads found in this list'))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Lead Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: AppStyles.roundedLarge,
                        border: Border.all(color: AppColors.border, width: 1.2),
                        boxShadow: AppStyles.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StatusBadge(status: lead.status),
                              if (lead.feedback != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceBlue,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    lead.feedback!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            lead.fullName,
                            style: AppStyles.h2,
                          ),
                          if (lead.company != null && lead.company!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              lead.company!,
                              style: AppStyles.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          const SizedBox(height: 18),
                          const Divider(color: AppColors.border),
                          const SizedBox(height: 16),

                          // Primary Phone
                          _buildDetailRow(
                            icon: Icons.phone_rounded,
                            label: 'Primary Phone',
                            value: lead.phone,
                            isPhone: true,
                            onPhoneTap: () => _makePhoneCall(context, lead.phone),
                          ),

                          // Alternate Phones
                          if (lead.otherPhones.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              icon: Icons.phone_forwarded_rounded,
                              label: 'Other Phones',
                              value: lead.otherPhones.join(', '),
                              isPhone: true,
                              onPhoneTap: () => _makePhoneCall(context, lead.otherPhones.first),
                            ),
                          ],

                          if (lead.email != null) ...[
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              icon: Icons.mail_outline_rounded,
                              label: 'Email',
                              value: lead.email!,
                            ),
                          ],

                          if (lead.address != null) ...[
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              icon: Icons.location_on_outlined,
                              label: 'Address',
                              value: lead.address!,
                            ),
                          ],

                          if (lead.notes != null) ...[
                            const SizedBox(height: 12),
                            _buildDetailRow(
                              icon: Icons.note_outlined,
                              label: 'Notes',
                              value: lead.notes!,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Controls: Call Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _makePhoneCall(context, lead.phone);
                        },
                        icon: const Icon(Icons.call_rounded, size: 22, color: Colors.white),
                        label: Text(
                          'Call ${lead.phone}',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.success,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: AppStyles.roundedMedium,
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Feedback & Disposition Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          CallFeedbackDialog.show(
                            context,
                            leadName: lead.fullName,
                            onSubmit: (data) {
                              listProvider.updateCurrentLeadStatus(
                                status: data['status'],
                                feedback: data['feedback'],
                              );
                              listProvider.nextLead();
                            },
                          );
                        },
                        icon: const Icon(Icons.rate_review_outlined, size: 20),
                        label: const Text('Record Disposition / Feedback'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppStyles.roundedMedium,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Navigation Controls: Previous / Next
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton.icon(
                          onPressed: currentIndex > 0
                              ? () => listProvider.previousLead()
                              : null,
                          icon: const Icon(Icons.arrow_back_ios_rounded, size: 16),
                          label: const Text('Previous'),
                        ),
                        Text(
                          '${currentIndex + 1} / $totalCalls',
                          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        TextButton.icon(
                          onPressed: currentIndex < totalCalls - 1
                              ? () => listProvider.nextLead()
                              : null,
                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                          label: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    bool isPhone = false,
    VoidCallback? onPhoneTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.textMuted),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: isPhone ? onPhoneTap : null,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: isPhone ? AppColors.primary : AppColors.textPrimary,
                    fontWeight: isPhone ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAllLeadsBottomSheet(BuildContext context, List<CallLeadModel> leads) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('All Contacts (${leads.length})', style: AppStyles.h3),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: leads.length,
                    separatorBuilder: (_, index) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final item = leads[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.surfaceBlue,
                          child: Text(
                            item.fullName.isNotEmpty ? item.fullName[0] : 'C',
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(item.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                        subtitle: Text(item.phone, style: AppStyles.bodySmall),
                        trailing: StatusBadge(status: item.status),
                        onTap: () {
                          context.read<CallingListProvider>().setLeadIndex(index);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
