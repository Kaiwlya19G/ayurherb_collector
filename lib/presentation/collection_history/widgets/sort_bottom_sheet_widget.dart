import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SortBottomSheetWidget extends StatelessWidget {
  final String currentSortOption;
  final Function(String) onSortChanged;

  const SortBottomSheetWidget({
    super.key,
    required this.currentSortOption,
    required this.onSortChanged,
  });

  static const List<Map<String, dynamic>> sortOptions = [
    {
      'key': 'newest_first',
      'title': 'Newest First',
      'subtitle': 'Most recent collections first',
      'icon': 'schedule',
    },
    {
      'key': 'oldest_first',
      'title': 'Oldest First',
      'subtitle': 'Oldest collections first',
      'icon': 'history',
    },
    {
      'key': 'quantity_high_low',
      'title': 'Quantity: High to Low',
      'subtitle': 'Largest quantities first',
      'icon': 'trending_down',
    },
    {
      'key': 'quantity_low_high',
      'title': 'Quantity: Low to High',
      'subtitle': 'Smallest quantities first',
      'icon': 'trending_up',
    },
    {
      'key': 'verification_status',
      'title': 'Verification Status',
      'subtitle': 'Verified collections first',
      'icon': 'verified',
    },
    {
      'key': 'herb_name_az',
      'title': 'Herb Name: A-Z',
      'subtitle': 'Alphabetical order',
      'icon': 'sort_by_alpha',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 10.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Text(
                  'Sort Collections',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Sort options
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: sortOptions.length,
              itemBuilder: (context, index) {
                final option = sortOptions[index];
                final isSelected = currentSortOption == option['key'];

                return ListTile(
                  leading: Container(
                    width: 10.w,
                    height: 10.w,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.1)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: option['icon'] as String,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                    ),
                  ),
                  title: Text(
                    option['title'] as String,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    option['subtitle'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  trailing: isSelected
                      ? CustomIconWidget(
                          iconName: 'check_circle',
                          color: theme.colorScheme.primary,
                          size: 24,
                        )
                      : null,
                  onTap: () {
                    onSortChanged(option['key'] as String);
                    Navigator.pop(context);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
