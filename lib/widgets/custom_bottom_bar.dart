import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Navigation item data class
class BottomNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const BottomNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// Custom Bottom Navigation Bar for agricultural application
/// Implements Adaptive Bottom Navigation pattern with large touch targets
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double elevation;

  // Hardcoded navigation items for agricultural app
  static const List<BottomNavItem> _navItems = [
    BottomNavItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
      route: '/collection-dashboard',
    ),
    BottomNavItem(
      icon: Icons.add_circle_outline,
      activeIcon: Icons.add_circle,
      label: 'New Entry',
      route: '/new-collection-entry',
    ),
    BottomNavItem(
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      label: 'History',
      route: '/collection-history',
    ),
    BottomNavItem(
      icon: Icons.qr_code_outlined,
      activeIcon: Icons.qr_code,
      label: 'QR Code',
      route: '/qr-code-display',
    ),
  ];

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color:
            backgroundColor ?? theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.2),
            offset: Offset(0, -2),
            blurRadius: elevation,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 72, // Increased height for better touch targets
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                _navItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = index == currentIndex;

                  return Expanded(
                    child: _BottomNavButton(
                      item: item,
                      isSelected: isSelected,
                      onTap: () => _handleTap(context, index),
                      selectedColor:
                          selectedItemColor ??
                          theme.bottomNavigationBarTheme.selectedItemColor,
                      unselectedColor:
                          unselectedItemColor ??
                          theme.bottomNavigationBarTheme.unselectedItemColor,
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, int index) {
    if (onTap != null) {
      onTap!(index);
    }

    // Navigate to the selected route
    final route = _navItems[index].route;
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute != route) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        route,
        (route) => false, // Clear navigation stack for main screens
      );
    }
  }

  /// Factory constructor for dashboard context
  factory CustomBottomBar.dashboard({ValueChanged<int>? onTap}) {
    return CustomBottomBar(currentIndex: 0, onTap: onTap);
  }

  /// Factory constructor for new entry context
  factory CustomBottomBar.newEntry({ValueChanged<int>? onTap}) {
    return CustomBottomBar(currentIndex: 1, onTap: onTap);
  }

  /// Factory constructor for history context
  factory CustomBottomBar.history({ValueChanged<int>? onTap}) {
    return CustomBottomBar(currentIndex: 2, onTap: onTap);
  }

  /// Factory constructor for QR code context
  factory CustomBottomBar.qrCode({ValueChanged<int>? onTap}) {
    return CustomBottomBar(currentIndex: 3, onTap: onTap);
  }
}

/// Individual bottom navigation button widget
class _BottomNavButton extends StatelessWidget {
  final BottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? selectedColor;
  final Color? unselectedColor;

  const _BottomNavButton({
    required this.item,
    required this.isSelected,
    required this.onTap,
    this.selectedColor,
    this.unselectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isSelected ? selectedColor : unselectedColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon with micro-feedback animation
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              padding: EdgeInsets.all(isSelected ? 4 : 2),
              decoration:
                  isSelected
                      ? BoxDecoration(
                        color: selectedColor?.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      )
                      : null,
              child: Icon(
                isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                size: 24, // Large touch-friendly size
                color: color,
              ),
            ),
            SizedBox(height: 4),
            // Label with agricultural-optimized typography
            Text(
              item.label,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                color: color,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
