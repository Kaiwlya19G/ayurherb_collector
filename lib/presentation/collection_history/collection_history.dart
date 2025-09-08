import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/collection_card_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chips_widget.dart';
import './widgets/search_overlay_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class CollectionHistory extends StatefulWidget {
  const CollectionHistory({super.key});

  @override
  State<CollectionHistory> createState() => _CollectionHistoryState();
}

class _CollectionHistoryState extends State<CollectionHistory>
    with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final RefreshIndicator _refreshIndicatorKey = RefreshIndicator(
    onRefresh: () async {},
    child: Container(),
  );

  bool _isSearchVisible = false;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  String _currentSortOption = 'newest_first';
  List<Map<String, dynamic>> _activeFilters = [];
  List<String> _recentSearches = ['Ashwagandha', 'Tulsi', 'Neem'];

  // Mock data for collections
  final List<Map<String, dynamic>> _allCollections = [
    {
      "id": 1,
      "collectionId": "AH001234",
      "herbSpecies": "Ashwagandha (अश्वगंधा)",
      "herbImage":
          "https://images.pexels.com/photos/4021775/pexels-photo-4021775.jpeg?auto=compress&cs=tinysrgb&w=800",
      "quantity": 2.5,
      "collectionDate": DateTime.now().subtract(Duration(days: 2)),
      "latitude": 19.0760,
      "longitude": 72.8777,
      "blockchainStatus": "Verified",
      "txId": "0x1a2b3c4d5e6f7890",
      "syncStatus": "Synced",
      "lastSyncTime": DateTime.now().subtract(Duration(hours: 1)),
    },
    {
      "id": 2,
      "collectionId": "AH001235",
      "herbSpecies": "Tulsi (तुलसी)",
      "herbImage":
          "https://images.pexels.com/photos/6207278/pexels-photo-6207278.jpeg?auto=compress&cs=tinysrgb&w=800",
      "quantity": 1.8,
      "collectionDate": DateTime.now().subtract(Duration(days: 5)),
      "latitude": 19.0825,
      "longitude": 72.8811,
      "blockchainStatus": "Pending",
      "txId": null,
      "syncStatus": "Pending",
      "lastSyncTime": DateTime.now().subtract(Duration(hours: 6)),
    },
    {
      "id": 3,
      "collectionId": "AH001236",
      "herbSpecies": "Neem (नीम)",
      "herbImage":
          "https://images.pexels.com/photos/7656742/pexels-photo-7656742.jpeg?auto=compress&cs=tinysrgb&w=800",
      "quantity": 3.2,
      "collectionDate": DateTime.now().subtract(Duration(days: 8)),
      "latitude": 19.0896,
      "longitude": 72.8656,
      "blockchainStatus": "Failed",
      "txId": null,
      "syncStatus": "Failed",
      "lastSyncTime": DateTime.now().subtract(Duration(days: 1)),
    },
    {
      "id": 4,
      "collectionId": "AH001237",
      "herbSpecies": "Brahmi (ब्राह्मी)",
      "herbImage":
          "https://images.pexels.com/photos/4750270/pexels-photo-4750270.jpeg?auto=compress&cs=tinysrgb&w=800",
      "quantity": 1.5,
      "collectionDate": DateTime.now().subtract(Duration(days: 12)),
      "latitude": 19.0728,
      "longitude": 72.8826,
      "blockchainStatus": "Verified",
      "txId": "0x9f8e7d6c5b4a3210",
      "syncStatus": "Synced",
      "lastSyncTime": DateTime.now().subtract(Duration(hours: 3)),
    },
    {
      "id": 5,
      "collectionId": "AH001238",
      "herbSpecies": "Amla (आंवला)",
      "herbImage":
          "https://images.pexels.com/photos/5966630/pexels-photo-5966630.jpeg?auto=compress&cs=tinysrgb&w=800",
      "quantity": 4.1,
      "collectionDate": DateTime.now().subtract(Duration(days: 15)),
      "latitude": 19.0653,
      "longitude": 72.8903,
      "blockchainStatus": "Verified",
      "txId": "0x5a6b7c8d9e0f1234",
      "syncStatus": "Synced",
      "lastSyncTime": DateTime.now().subtract(Duration(minutes: 30)),
    },
  ];

  List<Map<String, dynamic>> _filteredCollections = [];
  List<String> _herbSpeciesSuggestions = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _initializeData() {
    _filteredCollections = List.from(_allCollections);
    _herbSpeciesSuggestions = _allCollections
        .map((collection) => collection['herbSpecies'] as String)
        .toSet()
        .toList();
    _applySorting();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreCollections();
    }
  }

  Future<void> _refreshCollections() async {
    setState(() => _isLoading = true);

    // Simulate API call for blockchain status updates
    await Future.delayed(Duration(seconds: 2));

    // Update blockchain statuses (simulate some changes)
    for (var collection in _allCollections) {
      if (collection['blockchainStatus'] == 'Pending') {
        // Randomly update some pending to verified
        if (DateTime.now().millisecond % 2 == 0) {
          collection['blockchainStatus'] = 'Verified';
          collection['txId'] =
              '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
          collection['syncStatus'] = 'Synced';
          collection['lastSyncTime'] = DateTime.now();
        }
      }
    }

    _applyFiltersAndSort();
    setState(() => _isLoading = false);

    // Show success feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Collections updated successfully'),
        backgroundColor: AppTheme.getSuccessColor(
            Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }

  Future<void> _loadMoreCollections() async {
    if (_isLoadingMore) return;

    setState(() => _isLoadingMore = true);

    // Simulate loading more data
    await Future.delayed(Duration(seconds: 1));

    setState(() => _isLoadingMore = false);
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isNotEmpty && !_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches.removeLast();
        }
      }
    });
    _applyFiltersAndSort();
  }

  void _clearSearch() {
    setState(() {
      _searchQuery = '';
    });
    _applyFiltersAndSort();
  }

  void _addFilter(String type, String value, int count) {
    setState(() {
      _activeFilters.removeWhere((filter) => filter['type'] == type);
      _activeFilters.add({
        'type': type,
        'value': value,
        'count': count,
      });
    });
    _applyFiltersAndSort();
  }

  void _removeFilter(String filterType) {
    setState(() {
      _activeFilters.removeWhere((filter) => filter['type'] == filterType);
    });
    _applyFiltersAndSort();
  }

  void _clearAllFilters() {
    setState(() {
      _activeFilters.clear();
    });
    _applyFiltersAndSort();
  }

  void _changeSortOption(String sortOption) {
    setState(() {
      _currentSortOption = sortOption;
    });
    _applySorting();
  }

  void _applyFiltersAndSort() {
    List<Map<String, dynamic>> filtered = List.from(_allCollections);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((collection) {
        final herbName = (collection['herbSpecies'] as String).toLowerCase();
        final collectionId =
            (collection['collectionId'] as String).toLowerCase();
        final date =
            _formatDate(collection['collectionDate'] as DateTime).toLowerCase();

        return herbName.contains(query) ||
            collectionId.contains(query) ||
            date.contains(query);
      }).toList();
    }

    // Apply active filters
    for (var filter in _activeFilters) {
      final type = filter['type'] as String;
      final value = filter['value'] as String;

      switch (type) {
        case 'herbSpecies':
          filtered = filtered
              .where((collection) =>
                  (collection['herbSpecies'] as String).contains(value))
              .toList();
          break;
        case 'syncStatus':
          filtered = filtered
              .where((collection) => collection['blockchainStatus'] == value)
              .toList();
          break;
        case 'dateRange':
          // Implement date range filtering logic
          break;
      }
    }

    setState(() {
      _filteredCollections = filtered;
    });

    _applySorting();
  }

  void _applySorting() {
    switch (_currentSortOption) {
      case 'newest_first':
        _filteredCollections.sort((a, b) => (b['collectionDate'] as DateTime)
            .compareTo(a['collectionDate'] as DateTime));
        break;
      case 'oldest_first':
        _filteredCollections.sort((a, b) => (a['collectionDate'] as DateTime)
            .compareTo(b['collectionDate'] as DateTime));
        break;
      case 'quantity_high_low':
        _filteredCollections.sort((a, b) =>
            (b['quantity'] as double).compareTo(a['quantity'] as double));
        break;
      case 'quantity_low_high':
        _filteredCollections.sort((a, b) =>
            (a['quantity'] as double).compareTo(b['quantity'] as double));
        break;
      case 'verification_status':
        _filteredCollections.sort((a, b) {
          final statusOrder = {'Verified': 0, 'Pending': 1, 'Failed': 2};
          return (statusOrder[a['blockchainStatus']] ?? 3)
              .compareTo(statusOrder[b['blockchainStatus']] ?? 3);
        });
        break;
      case 'herb_name_az':
        _filteredCollections.sort((a, b) =>
            (a['herbSpecies'] as String).compareTo(b['herbSpecies'] as String));
        break;
    }

    setState(() {});
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SortBottomSheetWidget(
        currentSortOption: _currentSortOption,
        onSortChanged: _changeSortOption,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _handleCollectionTap(Map<String, dynamic> collection) {
    // Navigate to collection details
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Opening collection ${collection['collectionId']}')),
    );
  }

  void _handleViewDetails(Map<String, dynamic> collection) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Viewing details for ${collection['collectionId']}')),
    );
  }

  void _handleShareQR(Map<String, dynamic> collection) {
    Navigator.pushNamed(context, '/qr-code-display');
  }

  void _handleRetrySync(Map<String, dynamic> collection) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Retrying sync for ${collection['collectionId']}'),
        backgroundColor: AppTheme.getWarningColor(
            Theme.of(context).brightness == Brightness.dark),
      ),
    );
  }

  void _handleDelete(Map<String, dynamic> collection) {
    setState(() {
      _allCollections.removeWhere((c) => c['id'] == collection['id']);
      _applyFiltersAndSort();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Collection ${collection['collectionId']} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _allCollections.add(collection);
              _applyFiltersAndSort();
            });
          },
        ),
      ),
    );
  }

  void _handleExport(Map<String, dynamic> collection) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Exporting ${collection['collectionId']}')),
    );
  }

  void _handleDuplicate(Map<String, dynamic> collection) {
    Navigator.pushNamed(context, '/new-collection-entry');
  }

  void _handleEdit(Map<String, dynamic> collection) {
    Navigator.pushNamed(context, '/new-collection-entry');
  }

  void _startCollecting() {
    Navigator.pushNamed(context, '/new-collection-entry');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Collection History',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: _toggleSearch,
            icon: CustomIconWidget(
              iconName: 'search',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Search Collections',
          ),
          IconButton(
            onPressed: _showSortOptions,
            icon: CustomIconWidget(
              iconName: 'sort',
              color: theme.appBarTheme.foregroundColor ??
                  theme.colorScheme.onPrimary,
              size: 24,
            ),
            tooltip: 'Sort Collections',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Filter chips
              FilterChipsWidget(
                activeFilters: _activeFilters,
                onRemoveFilter: _removeFilter,
                onClearAll: _clearAllFilters,
              ),

              // Main content
              Expanded(
                child: _isLoading
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 2.h),
                            Text(
                              'Updating blockchain status...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : _filteredCollections.isEmpty
                        ? EmptyStateWidget(
                            type: _searchQuery.isNotEmpty ||
                                    _activeFilters.isNotEmpty
                                ? 'no_search_results'
                                : 'no_collections',
                            searchQuery:
                                _searchQuery.isNotEmpty ? _searchQuery : null,
                            onStartCollecting: _startCollecting,
                            onClearSearch: _clearSearch,
                          )
                        : RefreshIndicator(
                            onRefresh: _refreshCollections,
                            child: ListView.builder(
                              controller: _scrollController,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _filteredCollections.length +
                                  (_isLoadingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _filteredCollections.length) {
                                  return Container(
                                    padding: EdgeInsets.all(4.w),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }

                                final collection = _filteredCollections[index];
                                return CollectionCardWidget(
                                  collection: collection,
                                  onTap: () => _handleCollectionTap(collection),
                                  onViewDetails: () =>
                                      _handleViewDetails(collection),
                                  onShareQR: () => _handleShareQR(collection),
                                  onRetrySync: () =>
                                      _handleRetrySync(collection),
                                  onDelete: () => _handleDelete(collection),
                                  onExport: () => _handleExport(collection),
                                  onDuplicate: () =>
                                      _handleDuplicate(collection),
                                  onEdit: () => _handleEdit(collection),
                                );
                              },
                            ),
                          ),
              ),
            ],
          ),

          // Search overlay
          if (_isSearchVisible)
            SearchOverlayWidget(
              initialQuery: _searchQuery,
              onSearch: _performSearch,
              onClose: () => setState(() => _isSearchVisible = false),
              recentSearches: _recentSearches,
              herbSpeciesSuggestions: _herbSpeciesSuggestions,
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar.history(),
    );
  }
}
