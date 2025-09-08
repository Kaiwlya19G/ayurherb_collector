import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class QrCodeWidget extends StatelessWidget {
  final String qrData;
  final double size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const QrCodeWidget({
    super.key,
    required this.qrData,
    this.size = 280.0,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (isDark ? AppTheme.lightTheme.colorScheme.surface : Colors.white),
        borderRadius: BorderRadius.circular(16.w),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: 0,
          ),
        ],
      ),
      child: QrImageView(
        data: qrData,
        version: QrVersions.auto,
        size: size.w,
        backgroundColor: backgroundColor ??
            (isDark ? AppTheme.lightTheme.colorScheme.surface : Colors.white),
        foregroundColor: foregroundColor ??
            (isDark
                ? AppTheme.darkTheme.colorScheme.onSurface
                : AppTheme.lightTheme.colorScheme.onSurface),
        errorCorrectionLevel: QrErrorCorrectLevel.M,
        padding: EdgeInsets.all(8.w),
        semanticsLabel: 'QR Code for herb collection traceability',
      ),
    );
  }
}
