import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyStateWidget extends StatelessWidget {
  final String type; // 'no_collections' or 'no_search_results'
  final String? searchQuery;
  final VoidCallback? onStartCollecting;
  final VoidCallback? onClearSearch;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.searchQuery,
    this.onStartCollecting,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: _getIconName(),
                  color: theme.colorScheme.primary,
                  size: 20.w,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              _getTitle(),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              _getDescription(),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // Action button
            if (type == 'no_collections' && onStartCollecting != null)
              ElevatedButton.icon(
                onPressed: onStartCollecting,
                icon: CustomIconWidget(
                  iconName: 'add',
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                label: Text('Start Collecting'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            else if (type == 'no_search_results' && onClearSearch != null)
              OutlinedButton.icon(
                onPressed: onClearSearch,
                icon: CustomIconWidget(
                  iconName: 'clear',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                label: Text('Clear Search'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getIconName() {
    switch (type) {
      case 'no_collections':
        return 'local_florist';
      case 'no_search_results':
        return 'search_off';
      default:
        return 'help_outline';
    }
  }

  String _getTitle() {
    switch (type) {
      case 'no_collections':
        return 'No Collections Yet';
      case 'no_search_results':
        return 'No Results Found';
      default:
        return 'Nothing Here';
    }
  }

  String _getDescription() {
    switch (type) {
      case 'no_collections':
        return 'Start your journey by collecting your first Ayurvedic herb. Every collection helps build a transparent supply chain.';
      case 'no_search_results':
        return searchQuery != null
            ? 'No collections found for "$searchQuery". Try adjusting your search terms or filters.'
            : 'No collections match your current filters. Try adjusting your search criteria.';
      default:
        return 'There\'s nothing to display right now.';
    }
  }
}
