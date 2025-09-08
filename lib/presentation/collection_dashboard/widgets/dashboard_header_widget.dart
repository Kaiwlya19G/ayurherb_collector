import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DashboardHeaderWidget extends StatelessWidget {
  final String farmerName;
  final String farmerId;
  final String locationAccuracy;
  final bool isOnline;
  final DateTime? lastSyncTime;

  const DashboardHeaderWidget({
    super.key,
    required this.farmerName,
    required this.farmerId,
    required this.locationAccuracy,
    required this.isOnline,
    this.lastSyncTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
            offset: Offset(0, 2),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'नमस्ते, $farmerName',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'किसान ID: $farmerId',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              _buildStatusIndicators(),
            ],
          ),
          SizedBox(height: 1.5.h),
          _buildLocationAccuracy(),
          if (lastSyncTime != null) ...[
            SizedBox(height: 1.h),
            _buildLastSyncInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildStatusIndicators() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: isOnline
                ? AppTheme.getSuccessColor(true).withValues(alpha: 0.1)
                : AppTheme.getWarningColor(true).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOnline
                  ? AppTheme.getSuccessColor(true)
                  : AppTheme.getWarningColor(true),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isOnline
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getWarningColor(true),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 1.w),
              Text(
                isOnline ? 'ऑनलाइन' : 'ऑफलाइन',
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isOnline
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getWarningColor(true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationAccuracy() {
    Color accuracyColor;
    String accuracyText;
    IconData accuracyIcon;

    switch (locationAccuracy.toLowerCase()) {
      case 'high':
        accuracyColor = AppTheme.getSuccessColor(true);
        accuracyText = 'उच्च स्थान सटीकता';
        accuracyIcon = Icons.gps_fixed;
        break;
      case 'moderate':
        accuracyColor = AppTheme.getWarningColor(true);
        accuracyText = 'मध्यम स्थान सटीकता';
        accuracyIcon = Icons.gps_not_fixed;
        break;
      case 'low':
        accuracyColor = AppTheme.lightTheme.colorScheme.error;
        accuracyText = 'कम स्थान सटीकता';
        accuracyIcon = Icons.gps_off;
        break;
      default:
        accuracyColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
        accuracyText = 'स्थान अनुपलब्ध';
        accuracyIcon = Icons.location_disabled;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: accuracyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accuracyColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: accuracyIcon.codePoint.toString(),
            color: accuracyColor,
            size: 20,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              accuracyText,
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: accuracyColor,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastSyncInfo() {
    final timeDifference = DateTime.now().difference(lastSyncTime!);
    String syncText;

    if (timeDifference.inMinutes < 1) {
      syncText = 'अभी सिंक किया गया';
    } else if (timeDifference.inHours < 1) {
      syncText = '${timeDifference.inMinutes} मिनट पहले सिंक';
    } else if (timeDifference.inDays < 1) {
      syncText = '${timeDifference.inHours} घंटे पहले सिंक';
    } else {
      syncText = '${timeDifference.inDays} दिन पहले सिंक';
    }

    return Row(
      children: [
        CustomIconWidget(
          iconName: Icons.sync.codePoint.toString(),
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.6),
          size: 16,
        ),
        SizedBox(width: 1.w),
        Text(
          'अंतिम सिंक: $syncText',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
