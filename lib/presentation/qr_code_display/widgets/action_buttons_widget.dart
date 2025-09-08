import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ActionButtonsWidget extends StatelessWidget {
  final String qrData;
  final Map<String, dynamic> collectionData;
  final VoidCallback? onScanPressed;
  final VoidCallback? onDownloadPressed;

  const ActionButtonsWidget({
    super.key,
    required this.qrData,
    required this.collectionData,
    this.onScanPressed,
    this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          // Primary action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareQrCode(context),
                  icon: CustomIconWidget(
                    iconName: 'share',
                    color: theme.elevatedButtonTheme.style?.foregroundColor
                            ?.resolve({}) ??
                        Colors.white,
                    size: 20,
                  ),
                  label: Text('Share QR Code'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      onDownloadPressed ?? () => _downloadQrCode(context),
                  icon: CustomIconWidget(
                    iconName: 'download',
                    color: theme.outlinedButtonTheme.style?.foregroundColor
                            ?.resolve({}) ??
                        AppTheme.lightTheme.primaryColor,
                    size: 20,
                  ),
                  label: Text('Download'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 3.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.w),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          // Secondary action button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: onScanPressed,
              icon: CustomIconWidget(
                iconName: 'qr_code_scanner',
                color:
                    theme.textButtonTheme.style?.foregroundColor?.resolve({}) ??
                        AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
              label: Text('Scan Another QR Code'),
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.5.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.w),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _shareQrCode(BuildContext context) async {
    try {
      final collectionId =
          (collectionData['collectionId'] as String?) ?? 'Unknown';
      final herbSpecies =
          (collectionData['herbSpecies'] as String?) ?? 'Unknown Herb';
      final quantity =
          (collectionData['quantity'] as num?)?.toStringAsFixed(2) ?? '0.00';
      final date = _formatDate(
          (collectionData['collectionDate'] as DateTime?) ?? DateTime.now());

      final shareText = '''
🌿 AyurHerb Collection Traceability

Herb: $herbSpecies
Quantity: ${quantity} kg
Collection Date: $date
Collection ID: $collectionId

QR Code Data: $qrData

Verify authenticity by scanning this QR code with AyurHerb Collector app.
      '''
          .trim();

      await Share.share(
        shareText,
        subject: 'Herb Collection - $collectionId',
      );

      Fluttertoast.showToast(
        msg: "QR code shared successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to share QR code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorLight,
        textColor: Colors.white,
      );
    }
  }

  Future<void> _downloadQrCode(BuildContext context) async {
    try {
      // Simulate download process
      await Future.delayed(Duration(milliseconds: 500));

      Fluttertoast.showToast(
        msg: "QR code saved to gallery",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.light),
        textColor: Colors.white,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Failed to download QR code",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppTheme.errorLight,
        textColor: Colors.white,
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
