import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';
import '../../models/call_lead_model.dart';
import '../../providers/calling_list_provider.dart';

class CallHistoryScreen extends StatefulWidget {
  const CallHistoryScreen({super.key});

  @override
  State<CallHistoryScreen> createState() => _CallHistoryScreenState();
}

class _CallHistoryScreenState extends State<CallHistoryScreen> {
  String _selectedFilter = 'all';

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
    final calledList = allCalls.where((c) => c.status == 'called' || c.calledAt != null).toList();

    List<CallLeadModel> filtered = calledList;
    if (_selectedFilter == 'satisfied') {
      filtered = calledList.where((c) => (c.feedback ?? '').toLowerCase().contains('satisfied')).toList();
    } else if (_selectedFilter == 'followup') {
      filtered = calledList.where((c) => (c.feedback ?? '').toLowerCase().contains('follow')).toList();
    }

    final totalSeconds = calledList.fold<int>(0, (sum, c) => sum + (c.duration ?? 0));
    final avgSeconds = calledList.isNotEmpty ? (totalSeconds / calledList.length).round() : 0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Analytics Summary Card
            Container(
              margin: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surfaceBlue.withValues(alpha: 0.4),
                borderRadius: AppStyles.roundedLarge,
                border: Border.all(color: AppColors.border, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatColumn('Calls Logged', '${calledList.length}', AppColors.primary),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _buildStatColumn('Total Duration', '${(totalSeconds / 60).toStringAsFixed(1)}m', AppColors.success),
                  Container(width: 1, height: 36, color: AppColors.border),
                  _buildStatColumn('Avg Time', '${avgSeconds}s', AppColors.secondary),
                ],
              ),
            ),

            // Filter Chips Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                children: [
                  _buildFilterChip('all', 'All Logs (${calledList.length})'),
                  const SizedBox(width: 8),
                  _buildFilterChip('satisfied', 'Satisfied'),
                  const SizedBox(width: 8),
                  _buildFilterChip('followup', 'Needs Follow-up'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Call Logs List
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surfaceBlue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.phone_callback_rounded,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('No Call Logs Recorded', style: AppStyles.h3),
                          const SizedBox(height: 6),
                          Text(
                            'Completed calls and recorded dispositions will appear here.',
                            textAlign: TextAlign.center,
                            style: AppStyles.bodyMedium,
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: filtered.length,
                      separatorBuilder: (_, index) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final call = filtered[index];
                        return _buildCallLogItem(call);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppStyles.caption,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _selectedFilter == key;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = key;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildCallLogItem(CallLeadModel lead) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: AppStyles.roundedMedium,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: AppStyles.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceGreen,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.call_made_rounded, color: AppColors.success, size: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lead.fullName,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (lead.duration != null)
                      Text(
                        '${lead.duration}s',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  lead.calledAt ?? '2025-06-22 19:41',
                  style: AppStyles.caption,
                ),
                if (lead.feedback != null) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceBlue,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      lead.feedback!,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 20),
            onPressed: () => _makePhoneCall(lead.phone),
          ),
        ],
      ),
    );
  }
}
