import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SearchOverlayWidget extends StatefulWidget {
  final String initialQuery;
  final Function(String) onSearch;
  final VoidCallback onClose;
  final List<String> recentSearches;
  final List<String> herbSpeciesSuggestions;

  const SearchOverlayWidget({
    super.key,
    required this.initialQuery,
    required this.onSearch,
    required this.onClose,
    required this.recentSearches,
    required this.herbSpeciesSuggestions,
  });

  @override
  State<SearchOverlayWidget> createState() => _SearchOverlayWidgetState();
}

class _SearchOverlayWidgetState extends State<SearchOverlayWidget>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<String> _filteredSuggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();

    _searchController.addListener(_onSearchChanged);

    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = [];
        _showSuggestions = false;
      } else {
        _filteredSuggestions = widget.herbSpeciesSuggestions
            .where((species) => species.toLowerCase().contains(query))
            .take(5)
            .toList();
        _showSuggestions = true;
      }
    });
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      widget.onSearch(query.trim());
      _closeOverlay();
    }
  }

  void _closeOverlay() {
    _animationController.reverse().then((_) {
      widget.onClose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Material(
            color: theme.colorScheme.surface.withValues(alpha: 0.95),
            child: SafeArea(
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search header
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: theme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                autofocus: true,
                                decoration: InputDecoration(
                                  hintText:
                                      'Search by herb name, collection ID, or date...',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(3.w),
                                    child: CustomIconWidget(
                                      iconName: 'search',
                                      color: theme.colorScheme.onSurfaceVariant,
                                      size: 20,
                                    ),
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            setState(() {
                                              _filteredSuggestions = [];
                                              _showSuggestions = false;
                                            });
                                          },
                                          icon: CustomIconWidget(
                                            iconName: 'clear',
                                            color: theme
                                                .colorScheme.onSurfaceVariant,
                                            size: 20,
                                          ),
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 4.w,
                                    vertical: 2.h,
                                  ),
                                ),
                                onSubmitted: _performSearch,
                                textInputAction: TextInputAction.search,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          TextButton(
                            onPressed: _closeOverlay,
                            child: Text(
                              'Cancel',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 3.h),

                      // Search suggestions or recent searches
                      Expanded(
                        child:
                            _showSuggestions && _filteredSuggestions.isNotEmpty
                                ? _buildSuggestions(context)
                                : _buildRecentSearches(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSuggestions(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Suggestions',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredSuggestions.length,
            itemBuilder: (context, index) {
              final suggestion = _filteredSuggestions[index];
              return ListTile(
                leading: CustomIconWidget(
                  iconName: 'local_florist',
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
                title: Text(
                  suggestion,
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () => _performSearch(suggestion),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentSearches(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.recentSearches.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search',
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              size: 48,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start typing to search your collections',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Searches',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 1.h),
        Expanded(
          child: ListView.builder(
            itemCount: widget.recentSearches.length,
            itemBuilder: (context, index) {
              final recentSearch = widget.recentSearches[index];
              return ListTile(
                leading: CustomIconWidget(
                  iconName: 'history',
                  color: theme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
                title: Text(
                  recentSearch,
                  style: theme.textTheme.bodyMedium,
                ),
                trailing: IconButton(
                  onPressed: () {
                    // Remove from recent searches
                  },
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 16,
                  ),
                ),
                onTap: () => _performSearch(recentSearch),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
