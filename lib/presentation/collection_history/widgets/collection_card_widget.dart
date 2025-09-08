import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CollectionCardWidget extends StatelessWidget {
  final Map<String, dynamic> collection;
  final VoidCallback? onTap;
  final VoidCallback? onViewDetails;
  final VoidCallback? onShareQR;
  final VoidCallback? onRetrySync;
  final VoidCallback? onDelete;
  final VoidCallback? onExport;
  final VoidCallback? onDuplicate;
  final VoidCallback? onEdit;

  const CollectionCardWidget({
    super.key,
    required this.collection,
    this.onTap,
    this.onViewDetails,
    this.onShareQR,
    this.onRetrySync,
    this.onDelete,
    this.onExport,
    this.onDuplicate,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(collection['id']),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onViewDetails?.call(),
              backgroundColor: AppTheme.lightTheme.primaryColor,
              foregroundColor: Colors.white,
              icon: Icons.visibility,
              label: 'View',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onShareQR?.call(),
              backgroundColor: AppTheme.getAccentColor(isDark),
              foregroundColor: Colors.black,
              icon: Icons.qr_code,
              label: 'Share QR',
              borderRadius: BorderRadius.circular(12),
            ),
            if (collection['blockchainStatus'] == 'Failed' ||
                collection['blockchainStatus'] == 'Pending')
              SlidableAction(
                onPressed: (_) => onRetrySync?.call(),
                backgroundColor: AppTheme.getWarningColor(isDark),
                foregroundColor: Colors.white,
                icon: Icons.sync,
                label: 'Retry',
                borderRadius: BorderRadius.circular(12),
              ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => _showDeleteConfirmation(context),
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onTap: onTap,
          onLongPress: () => _showContextMenu(context),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Herb thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CustomImageWidget(
                          imageUrl: collection['herbImage'] as String,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      // Collection details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    collection['herbSpecies'] as String,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                _buildStatusBadge(context),
                              ],
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              '${collection['quantity']} kg',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: AppTheme.lightTheme.primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              _formatDate(
                                  collection['collectionDate'] as DateTime),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  // GPS coordinates and collection ID
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'GPS: ${collection['latitude']?.toStringAsFixed(6)}, ${collection['longitude']?.toStringAsFixed(6)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'tag',
                              color: theme.colorScheme.onSurfaceVariant,
                              size: 16,
                            ),
                            SizedBox(width: 2.w),
                            Expanded(
                              child: Text(
                                'ID: ${collection['collectionId']}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontFamily: 'monospace',
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    final theme = Theme.of(context);
    final status = collection['blockchainStatus'] as String;

    Color badgeColor;
    Color textColor;
    IconData icon;

    switch (status) {
      case 'Verified':
        badgeColor =
            AppTheme.getSuccessColor(theme.brightness == Brightness.dark);
        textColor = Colors.white;
        icon = Icons.verified;
        break;
      case 'Pending':
        badgeColor =
            AppTheme.getWarningColor(theme.brightness == Brightness.dark);
        textColor = Colors.white;
        icon = Icons.pending;
        break;
      case 'Failed':
        badgeColor = theme.colorScheme.error;
        textColor = Colors.white;
        icon = Icons.error;
        break;
      default:
        badgeColor = theme.colorScheme.onSurfaceVariant;
        textColor = Colors.white;
        icon = Icons.help;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: icon.codePoint.toString(),
            color: textColor,
            size: 12,
          ),
          SizedBox(width: 1.w),
          Text(
            status,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Collection'),
        content: Text(
            'Are you sure you want to delete this collection? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'file_download',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Export'),
              onTap: () {
                Navigator.pop(context);
                onExport?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'content_copy',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Duplicate'),
              onTap: () {
                Navigator.pop(context);
                onDuplicate?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                onEdit?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
