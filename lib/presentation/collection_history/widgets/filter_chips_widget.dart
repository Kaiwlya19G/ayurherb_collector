import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class FilterChipsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> activeFilters;
  final Function(String filterType) onRemoveFilter;
  final VoidCallback onClearAll;

  const FilterChipsWidget({
    super.key,
    required this.activeFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (activeFilters.isEmpty) {
      return SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Spacer(),
              if (activeFilters.length > 1)
                TextButton(
                  onPressed: onClearAll,
                  child: Text(
                    'Clear All',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: activeFilters
                .map((filter) => _buildFilterChip(context, filter))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, Map<String, dynamic> filter) {
    final theme = Theme.of(context);
    final filterType = filter['type'] as String;
    final filterValue = filter['value'] as String;
    final count = filter['count'] as int? ?? 0;

    return Chip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _getFilterDisplayText(filterType, filterValue),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (count > 0) ...[
            SizedBox(width: 1.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.2.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                count.toString(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
      deleteIcon: CustomIconWidget(
        iconName: 'close',
        color: theme.colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onDeleted: () => onRemoveFilter(filterType),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: theme.colorScheme.outline.withValues(alpha: 0.5),
        width: 1,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }

  String _getFilterDisplayText(String filterType, String filterValue) {
    switch (filterType) {
      case 'dateRange':
        return 'Date: $filterValue';
      case 'herbSpecies':
        return 'Herb: $filterValue';
      case 'syncStatus':
        return 'Status: $filterValue';
      case 'quantity':
        return 'Quantity: $filterValue';
      default:
        return filterValue;
    }
  }
}
