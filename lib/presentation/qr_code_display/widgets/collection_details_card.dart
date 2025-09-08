import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollectionDetailsCard extends StatelessWidget {
  final Map<String, dynamic> collectionData;

  const CollectionDetailsCard({
    super.key,
    required this.collectionData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w),
      ),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
              context,
              'Herb Species',
              (collectionData['herbSpecies'] as String?) ?? 'Unknown Herb',
              CustomIconWidget(
                iconName: 'grass',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'Quantity',
              '${(collectionData['quantity'] as num?)?.toStringAsFixed(2) ?? '0.00'} kg',
              CustomIconWidget(
                iconName: 'scale',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'Collection Date',
              _formatDate((collectionData['collectionDate'] as DateTime?) ??
                  DateTime.now()),
              CustomIconWidget(
                iconName: 'calendar_today',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'Farmer ID',
              (collectionData['farmerId'] as String?) ?? 'Unknown',
              CustomIconWidget(
                iconName: 'person',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'Collection ID',
              (collectionData['collectionId'] as String?) ?? 'Unknown',
              CustomIconWidget(
                iconName: 'fingerprint',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'GPS Coordinates',
              _formatCoordinates(
                (collectionData['latitude'] as double?) ?? 0.0,
                (collectionData['longitude'] as double?) ?? 0.0,
              ),
              CustomIconWidget(
                iconName: 'location_on',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
            SizedBox(height: 3.h),
            _buildDetailRow(
              context,
              'Transaction ID',
              (collectionData['transactionId'] as String?) ?? 'Pending',
              CustomIconWidget(
                iconName: 'receipt_long',
                color: AppTheme.lightTheme.primaryColor,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      BuildContext context, String label, String value, Widget icon) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCoordinates(double lat, double lng) {
    return '${lat.toStringAsFixed(6)}, ${lng.toStringAsFixed(6)}';
  }
}
