import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BlockchainStatusWidget extends StatelessWidget {
  final String status;
  final DateTime? lastVerified;
  final bool isOnline;

  const BlockchainStatusWidget({
    super.key,
    required this.status,
    this.lastVerified,
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor(status);
    final statusIcon = _getStatusIcon(status);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.w),
                ),
                child: CustomIconWidget(
                  iconName: statusIcon,
                  color: statusColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Blockchain Status',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      _getStatusText(status),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isOnline)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'wifi_off',
                        color: AppTheme.getWarningColor(
                            theme.brightness == Brightness.light),
                        size: 12,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Offline',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.getWarningColor(
                              theme.brightness == Brightness.light),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (lastVerified != null) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Last verified: ${_formatTimestamp(lastVerified!)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'confirmed':
        return AppTheme.successLight;
      case 'pending':
      case 'processing':
        return AppTheme.warningLight;
      case 'failed':
      case 'error':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'confirmed':
        return 'verified';
      case 'pending':
      case 'processing':
        return 'hourglass_empty';
      case 'failed':
      case 'error':
        return 'error';
      default:
        return 'help';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'Blockchain Verified';
      case 'confirmed':
        return 'Transaction Confirmed';
      case 'pending':
        return 'Pending Verification';
      case 'processing':
        return 'Processing Transaction';
      case 'failed':
        return 'Verification Failed';
      case 'error':
        return 'Transaction Error';
      default:
        return 'Unknown Status';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
