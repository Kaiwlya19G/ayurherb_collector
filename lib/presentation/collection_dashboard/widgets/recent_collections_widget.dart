import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentCollectionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> recentCollections;
  final VoidCallback? onViewAllTap;
  final Function(Map<String, dynamic>)? onCollectionTap;
  final Function(Map<String, dynamic>)? onViewQRCode;
  final Function(Map<String, dynamic>)? onShare;
  final Function(Map<String, dynamic>)? onRetrySync;
  final Function(Map<String, dynamic>)? onEdit;
  final Function(Map<String, dynamic>)? onDelete;
  final Function(Map<String, dynamic>)? onDuplicate;

  const RecentCollectionsWidget({
    super.key,
    required this.recentCollections,
    this.onViewAllTap,
    this.onCollectionTap,
    this.onViewQRCode,
    this.onShare,
    this.onRetrySync,
    this.onEdit,
    this.onDelete,
    this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'हाल के संग्रह',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              if (recentCollections.isNotEmpty)
                TextButton(
                  onPressed: onViewAllTap,
                  child: Text(
                    'सभी देखें',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 1.h),
        recentCollections.isEmpty
            ? _buildEmptyState()
            : _buildCollectionsList(),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: Icons.eco.codePoint.toString(),
            color:
                AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.5),
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'अपना पहला संग्रह शुरू करें',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'आयुर्वेदिक जड़ी-बूटियों का संग्रह करना शुरू करने के लिए नीचे दिए गए बटन पर टैप करें',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      itemCount: recentCollections.length > 5 ? 5 : recentCollections.length,
      separatorBuilder: (context, index) => SizedBox(height: 2.h),
      itemBuilder: (context, index) {
        final collection = recentCollections[index];
        return _buildCollectionItem(collection);
      },
    );
  }

  Widget _buildCollectionItem(Map<String, dynamic> collection) {
    final syncStatus = collection['syncStatus'] as String? ?? 'pending';
    final herbName = collection['herbName'] as String? ?? '';
    final quantity = collection['quantity'] as double? ?? 0.0;
    final imageUrl = collection['imageUrl'] as String? ?? '';
    final collectionDate =
        collection['collectionDate'] as DateTime? ?? DateTime.now();
    final blockchainStatus =
        collection['blockchainStatus'] as String? ?? 'pending';

    return Slidable(
      key: ValueKey(collection['id']),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onViewQRCode?.call(collection),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.qr_code,
            label: 'QR कोड',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (context) => onShare?.call(collection),
            backgroundColor: AppTheme.getAccentColor(true),
            foregroundColor: Colors.black,
            icon: Icons.share,
            label: 'साझा करें',
            borderRadius: BorderRadius.circular(8),
          ),
          if (syncStatus == 'pending')
            SlidableAction(
              onPressed: (context) => onRetrySync?.call(collection),
              backgroundColor: AppTheme.getWarningColor(true),
              foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
              icon: Icons.sync,
              label: 'सिंक करें',
              borderRadius: BorderRadius.circular(8),
            ),
        ],
      ),
      child: GestureDetector(
        onTap: () => onCollectionTap?.call(collection),
        onLongPress: () => _showContextMenu(collection),
        child: Container(
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
          ),
          child: Row(
            children: [
              _buildCollectionImage(imageUrl),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            herbName,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.lightTheme.colorScheme.onSurface,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildSyncStatusBadge(syncStatus),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '${quantity.toStringAsFixed(1)} किग्रा',
                      style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: Icons.access_time.codePoint.toString(),
                          color: AppTheme.lightTheme.colorScheme.onSurface
                              .withValues(alpha: 0.6),
                          size: 14,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          _formatDate(collectionDate),
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        _buildBlockchainStatusIcon(blockchainStatus),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionImage(String imageUrl) {
    return Container(
      width: 15.w,
      height: 15.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageUrl.isNotEmpty
            ? CustomImageWidget(
                imageUrl: imageUrl,
                width: 15.w,
                height: 15.w,
                fit: BoxFit.cover,
              )
            : CustomIconWidget(
                iconName: Icons.eco.codePoint.toString(),
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.5),
                size: 24,
              ),
      ),
    );
  }

  Widget _buildSyncStatusBadge(String status) {
    Color statusColor;
    String statusText;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'synced':
        statusColor = AppTheme.getSuccessColor(true);
        statusText = 'सिंक';
        statusIcon = Icons.check_circle;
        break;
      case 'pending':
        statusColor = AppTheme.getWarningColor(true);
        statusText = 'प्रतीक्षित';
        statusIcon = Icons.sync_problem;
        break;
      case 'failed':
        statusColor = AppTheme.lightTheme.colorScheme.error;
        statusText = 'असफल';
        statusIcon = Icons.error;
        break;
      default:
        statusColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
        statusText = 'अज्ञात';
        statusIcon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: statusIcon.codePoint.toString(),
            color: statusColor,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            statusText,
            style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockchainStatusIcon(String status) {
    Color statusColor;
    IconData statusIcon;

    switch (status.toLowerCase()) {
      case 'verified':
        statusColor = AppTheme.getSuccessColor(true);
        statusIcon = Icons.verified;
        break;
      case 'pending':
        statusColor = AppTheme.getWarningColor(true);
        statusIcon = Icons.hourglass_empty;
        break;
      case 'failed':
        statusColor = AppTheme.lightTheme.colorScheme.error;
        statusIcon = Icons.error_outline;
        break;
      default:
        statusColor =
            AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.5);
        statusIcon = Icons.help_outline;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: statusIcon.codePoint.toString(),
          color: statusColor,
          size: 14,
        ),
        SizedBox(width: 1.w),
        Text(
          'ब्लॉकचेन',
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: statusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'आज ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'कल ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} दिन पहले';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showContextMenu(Map<String, dynamic> collection) {
    // This would typically show a bottom sheet or dialog with options
    // For now, we'll just call the available callbacks
  }
}
