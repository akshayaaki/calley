import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/call_lead_model.dart';
import '../../providers/calling_list_provider.dart';
import '../../widgets/common/status_badge.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  Future<void> _makePhoneCall(String phoneNumber) async {
    final uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = context.watch<CallingListProvider>();
    final allCalls = listProvider.listDetails?.calls ?? [];
    // Get all rescheduled/scheduled leads or leads with rescheduledAt
    final scheduledCalls = allCalls.where((c) => c.status == 'rescheduled' || c.rescheduledAt != null).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Header & Date Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                border: const Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                boxShadow: AppStyles.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('MMMM yyyy').format(_selectedDate),
                            style: AppStyles.h2.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('EEEE, d MMM').format(_selectedDate),
                            style: AppStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.surfacePurple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.event_available_rounded, size: 16, color: AppColors.reschedule),
                            const SizedBox(width: 6),
                            Text(
                              '${scheduledCalls.length} Scheduled',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.reschedule,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Horizontal Date Picker Strip (Next 7 days)
                  SizedBox(
                    height: 70,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 14,
                      separatorBuilder: (_, index) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final date = DateTime.now().add(Duration(days: index));
                        final isSelected = date.year == _selectedDate.year &&
                            date.month == _selectedDate.month &&
                            date.day == _selectedDate.day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDate = date;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            width: 52,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surfaceBlue.withValues(alpha: 0.3),
                              borderRadius: AppStyles.roundedMedium,
                              border: Border.all(
                                color: isSelected ? AppColors.primary : AppColors.border,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat('E').format(date).toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected ? Colors.white70 : AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${date.day}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Scheduled List Section
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Follow-up Queue',
                    style: AppStyles.h3.copyWith(fontSize: 15),
                  ),
                  Text(
                    '${scheduledCalls.length} contacts',
                    style: AppStyles.bodySmall,
                  ),
                ],
              ),
            ),

            Expanded(
              child: scheduledCalls.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surfacePurple,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calendar_today_rounded,
                              color: AppColors.reschedule,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Scheduled Calls',
                            style: AppStyles.h3,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Calls you reschedule during dialing sessions will appear here.',
                            textAlign: TextAlign.center,
                            style: AppStyles.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: scheduledCalls.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final call = scheduledCalls[index];
                        return _buildScheduledCard(call);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduledCard(CallLeadModel lead) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppStyles.roundedMedium,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surfacePurple,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 13, color: AppColors.reschedule),
                    const SizedBox(width: 5),
                    Text(
                      lead.rescheduledAt ?? 'Today 04:30 PM',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.reschedule,
                      ),
                    ),
                  ],
                ),
              ),
              StatusBadge(status: lead.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lead.fullName,
            style: AppStyles.h3.copyWith(fontSize: 15),
          ),
          if (lead.company != null && lead.company!.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              lead.company!,
              style: AppStyles.bodySmall,
            ),
          ],
          if (lead.notes != null && lead.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                lead.notes!,
                style: AppStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _makePhoneCall(lead.phone),
                  icon: const Icon(Icons.call_rounded, size: 16),
                  label: Text('Call ${lead.phone}'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
