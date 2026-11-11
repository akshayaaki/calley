import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class CallFeedbackDialog extends StatefulWidget {
  final String leadName;
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const CallFeedbackDialog({
    super.key,
    required this.leadName,
    required this.onSubmit,
  });

  static Future<void> show(
    BuildContext context, {
    required String leadName,
    required ValueChanged<Map<String, dynamic>> onSubmit,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CallFeedbackDialog(leadName: leadName, onSubmit: onSubmit),
    );
  }

  @override
  State<CallFeedbackDialog> createState() => _CallFeedbackDialogState();
}

class _CallFeedbackDialogState extends State<CallFeedbackDialog> {
  String _selectedStatus = 'called';
  String _selectedFeedback = 'Satisfied';
  final _notesController = TextEditingController();

  final List<String> _feedbackOptions = [
    'Satisfied',
    'Neutral',
    'Needs follow-up',
    'Not Interested',
    'Callback Requested',
    'Wrong Number',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: AppStyles.roundedLarge),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Call Feedback',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.leadName,
            style: AppStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Call Outcome',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildOutcomeChip('called', 'Done', AppColors.success),
                const SizedBox(width: 8),
                _buildOutcomeChip('rescheduled', 'Reschedule', AppColors.reschedule),
                const SizedBox(width: 8),
                _buildOutcomeChip('pending', 'Pending', AppColors.warning),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Feedback Disposition',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: AppStyles.roundedMedium,
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedFeedback,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: _feedbackOptions.map((f) {
                    return DropdownMenuItem(value: f, child: Text(f, style: AppStyles.bodyMedium));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedFeedback = val;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Call Notes',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              maxLines: 2,
              style: AppStyles.bodyMedium,
              decoration: const InputDecoration(
                hintText: 'Enter meeting notes or feedback...',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit({
              'status': _selectedStatus,
              'feedback': _selectedFeedback,
              'notes': _notesController.text.trim(),
            });
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: AppStyles.roundedSmall),
          ),
          child: const Text('Save & Next'),
        ),
      ],
    );
  }

  Widget _buildOutcomeChip(String value, String label, Color color) {
    final isSelected = _selectedStatus == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedStatus = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? color : color.withValues(alpha: 0.1),
            borderRadius: AppStyles.roundedSmall,
            border: Border.all(color: color, width: 1.2),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : color,
            ),
          ),
        ),
      ),
    );
  }
}

