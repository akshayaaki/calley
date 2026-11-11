import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showLeading;
  final VoidCallback? onLeadingPressed;
  final List<Widget>? actions;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showLeading = true,
    this.onLeadingPressed,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      centerTitle: centerTitle,
      leading: showLeading
          ? (onLeadingPressed != null
              ? IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 24),
                  onPressed: onLeadingPressed,
                )
              : Builder(
                  builder: (scaffoldCtx) => IconButton(
                    icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary, size: 24),
                    onPressed: () => Scaffold.of(scaffoldCtx).openDrawer(),
                  ),
                ))
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.2,
        ),
      ),
      actions: actions ?? [
        IconButton(
          icon: const Icon(Icons.support_agent_rounded, color: AppColors.textPrimary, size: 22),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connecting to Calley Support Desk...')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary, size: 22),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('No new notifications')),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
