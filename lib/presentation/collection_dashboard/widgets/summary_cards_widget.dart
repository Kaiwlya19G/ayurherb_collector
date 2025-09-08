import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SummaryCardsWidget extends StatelessWidget {
  final int todayCollections;
  final int pendingSyncItems;
  final int verifiedCollections;
  final VoidCallback? onTodayCollectionsTap;
  final VoidCallback? onPendingSyncTap;
  final VoidCallback? onVerifiedTap;

  const SummaryCardsWidget({
    super.key,
    required this.todayCollections,
    required this.pendingSyncItems,
    required this.verifiedCollections,
    this.onTodayCollectionsTap,
    this.onPendingSyncTap,
    this.onVerifiedTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  title: 'आज का संग्रह',
                  value: todayCollections.toString(),
                  icon: Icons.today,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  onTap: onTodayCollectionsTap,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSummaryCard(
                  title: 'सिंक प्रतीक्षित',
                  value: pendingSyncItems.toString(),
                  icon: Icons.sync_problem,
                  color: AppTheme.getWarningColor(true),
                  onTap: onPendingSyncTap,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildSummaryCard(
            title: 'ब्लॉकचेन सत्यापित संग्रह',
            value: verifiedCollections.toString(),
            icon: Icons.verified,
            color: AppTheme.getSuccessColor(true),
            onTap: onVerifiedTap,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
    bool isFullWidth = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.1),
              offset: Offset(0, 2),
              blurRadius: 8,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: CustomIconWidget(
                    iconName: icon.codePoint.toString(),
                    color: color,
                    size: 24,
                  ),
                ),
                if (onTap != null)
                  CustomIconWidget(
                    iconName: Icons.arrow_forward_ios.codePoint.toString(),
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.4),
                    size: 16,
                  ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              value,
              style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
                fontWeight: FontWeight.w500,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
