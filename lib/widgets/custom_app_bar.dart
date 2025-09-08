import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for agricultural application
/// Implements Contemporary Agricultural Minimalism design principles
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final bool centerTitle;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.onBackPressed,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 2.0,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.roboto(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: foregroundColor ?? theme.appBarTheme.foregroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: foregroundColor ?? theme.appBarTheme.foregroundColor,
      elevation: elevation,
      shadowColor: theme.appBarTheme.shadowColor,
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: foregroundColor ?? theme.appBarTheme.foregroundColor,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                  tooltip: 'Back',
                )
              : null),
      actions: actions != null
          ? [
              ...actions!,
              SizedBox(width: 8), // Padding for actions
            ]
          : null,
      // Large touch targets for rural users
      toolbarHeight: 56.0,
      titleSpacing: 16.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  /// Factory constructor for collection screens
  factory CustomAppBar.collection({
    required String title,
    VoidCallback? onSyncPressed,
    VoidCallback? onSettingsPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        if (onSyncPressed != null)
          IconButton(
            icon: Icon(Icons.sync, size: 24),
            onPressed: onSyncPressed,
            tooltip: 'Sync Data',
          ),
        if (onSettingsPressed != null)
          IconButton(
            icon: Icon(Icons.settings, size: 24),
            onPressed: onSettingsPressed,
            tooltip: 'Settings',
          ),
      ],
    );
  }

  /// Factory constructor for dashboard screen
  factory CustomAppBar.dashboard({
    VoidCallback? onProfilePressed,
    VoidCallback? onNotificationPressed,
  }) {
    return CustomAppBar(
      title: 'Collection Dashboard',
      showBackButton: false,
      actions: [
        if (onNotificationPressed != null)
          IconButton(
            icon: Icon(Icons.notifications_outlined, size: 24),
            onPressed: onNotificationPressed,
            tooltip: 'Notifications',
          ),
        if (onProfilePressed != null)
          IconButton(
            icon: Icon(Icons.account_circle_outlined, size: 24),
            onPressed: onProfilePressed,
            tooltip: 'Profile',
          ),
      ],
    );
  }

  /// Factory constructor for entry screens
  factory CustomAppBar.entry({
    required String title,
    VoidCallback? onSavePressed,
    VoidCallback? onCameraPressed,
  }) {
    return CustomAppBar(
      title: title,
      actions: [
        if (onCameraPressed != null)
          IconButton(
            icon: Icon(Icons.camera_alt_outlined, size: 24),
            onPressed: onCameraPressed,
            tooltip: 'Take Photo',
          ),
        if (onSavePressed != null)
          IconButton(
            icon: Icon(Icons.save_outlined, size: 24),
            onPressed: onSavePressed,
            tooltip: 'Save Entry',
          ),
      ],
    );
  }
}
