import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_styles.dart';

class WhatsAppButton extends StatelessWidget {
  final double size;
  final String? phoneNumber;
  final String? message;

  const WhatsAppButton({
    super.key,
    this.size = 52,
    this.phoneNumber = '919971125588',
    this.message = 'Hi, I need assistance with Calley Automatic Call Dialer.',
  });

  Future<void> _launchWhatsApp(BuildContext context) async {
    final url = Uri.parse(
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message ?? '')}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch WhatsApp')),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: AppStyles.roundedMedium,
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppStyles.roundedMedium,
          onTap: () => _launchWhatsApp(context),
          child: Center(
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.whatsapp,
              size: size * 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

