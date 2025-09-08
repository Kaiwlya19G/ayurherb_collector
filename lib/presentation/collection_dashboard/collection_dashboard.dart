import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/recent_collections_widget.dart';
import './widgets/summary_cards_widget.dart';

class CollectionDashboard extends StatefulWidget {
  const CollectionDashboard({super.key});

  @override
  State<CollectionDashboard> createState() => _CollectionDashboardState();
}

class _CollectionDashboardState extends State<CollectionDashboard> {
  bool _isOnline = true;
  bool _isRefreshing = false;
  DateTime? _lastSyncTime;

  // Mock data for dashboard
  final Map<String, dynamic> _farmerData = {
    "farmerId": "AH001234",
    "farmerName": "राजेश कुमार",
    "locationAccuracy": "high",
    "todayCollections": 3,
    "pendingSyncItems": 2,
    "verifiedCollections": 15,
  };

  final List<Map<String, dynamic>> _recentCollections = [
    {
      "id": "COL001",
      "herbName": "अश्वगंधा",
      "quantity": 2.5,
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "collectionDate": DateTime.now().subtract(Duration(hours: 2)),
      "syncStatus": "synced",
      "blockchainStatus": "verified",
      "txId": "0x1a2b3c4d5e6f7890",
    },
    {
      "id": "COL002",
      "herbName": "तुलसी",
      "quantity": 1.8,
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "collectionDate": DateTime.now().subtract(Duration(hours: 5)),
      "syncStatus": "pending",
      "blockchainStatus": "pending",
      "txId": null,
    },
    {
      "id": "COL003",
      "herbName": "नीम",
      "quantity": 3.2,
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "collectionDate": DateTime.now().subtract(Duration(days: 1)),
      "syncStatus": "synced",
      "blockchainStatus": "verified",
      "txId": "0x9f8e7d6c5b4a3210",
    },
    {
      "id": "COL004",
      "herbName": "ब्राह्मी",
      "quantity": 1.5,
      "imageUrl":
          "https://images.pexels.com/photos/4750274/pexels-photo-4750274.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1",
      "collectionDate": DateTime.now().subtract(Duration(days: 2)),
      "syncStatus": "failed",
      "blockchainStatus": "failed",
      "txId": null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _lastSyncTime = DateTime.now().subtract(Duration(minutes: 15));
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isOnline = true; // Mock online status
      });
    }
  }

  Future<void> _handleRefresh() async {
    if (!_isOnline) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // Simulate sync operation
      await Future.delayed(Duration(seconds: 2));

      // Update sync status for pending items
      for (var collection in _recentCollections) {
        if ((collection['syncStatus'] as String) == 'pending') {
          collection['syncStatus'] = 'synced';
          collection['blockchainStatus'] = 'verified';
          collection['txId'] =
              '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
        }
      }

      setState(() {
        _lastSyncTime = DateTime.now();
        _farmerData['pendingSyncItems'] = 0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('सिंक सफलतापूर्वक पूरा हुआ'),
            backgroundColor: AppTheme.getSuccessColor(true),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('सिंक में त्रुटि हुई'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _navigateToNewCollection() {
    Navigator.pushNamed(context, '/new-collection-entry');
  }

  void _navigateToHistory() {
    Navigator.pushNamed(context, '/collection-history');
  }

  void _handleCollectionTap(Map<String, dynamic> collection) {
    // Navigate to collection details or show details dialog
    _showCollectionDetails(collection);
  }

  void _showCollectionDetails(Map<String, dynamic> collection) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildCollectionDetailsSheet(collection),
    );
  }

  Widget _buildCollectionDetailsSheet(Map<String, dynamic> collection) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(
                alpha: 0.3,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    collection['herbName'] as String,
                    style: AppTheme.lightTheme.textTheme.headlineSmall
                        ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(height: 2.h),
                  _buildDetailRow(
                    'मात्रा',
                    '${(collection['quantity'] as double).toStringAsFixed(1)} किग्रा',
                  ),
                  _buildDetailRow(
                    'संग्रह दिनांक',
                    _formatDetailDate(collection['collectionDate'] as DateTime),
                  ),
                  _buildDetailRow(
                    'सिंक स्थिति',
                    collection['syncStatus'] as String,
                  ),
                  _buildDetailRow(
                    'ब्लॉकचेन स्थिति',
                    collection['blockchainStatus'] as String,
                  ),
                  if (collection['txId'] != null)
                    _buildDetailRow(
                      'Transaction ID',
                      collection['txId'] as String,
                    ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _handleViewQRCode(collection),
                          icon: CustomIconWidget(
                            iconName: Icons.qr_code.codePoint.toString(),
                            color: AppTheme.lightTheme.colorScheme.onPrimary,
                            size: 20,
                          ),
                          label: Text('QR कोड देखें'),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => _handleShare(collection),
                          icon: CustomIconWidget(
                            iconName: Icons.share.codePoint.toString(),
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          label: Text('साझा करें'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 30.w,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface.withValues(
                  alpha: 0.7,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDetailDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _handleViewQRCode(Map<String, dynamic> collection) {
    Navigator.pop(context);
    Navigator.pushNamed(context, '/qr-code-display', arguments: collection);
  }

  void _handleShare(Map<String, dynamic> collection) {
    Navigator.pop(context);
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('साझाकरण सुविधा जल्द ही उपलब्ध होगी'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleRetrySync(Map<String, dynamic> collection) {
    if (!_isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('सिंक के लिए इंटरनेट कनेक्शन आवश्यक है'),
          backgroundColor: AppTheme.getWarningColor(true),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Simulate retry sync
    setState(() {
      collection['syncStatus'] = 'synced';
      collection['blockchainStatus'] = 'verified';
      collection['txId'] =
          '0x${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}';
      _farmerData['pendingSyncItems'] =
          (_farmerData['pendingSyncItems'] as int) - 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('सिंक सफल हुआ'),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: AppTheme.lightTheme.colorScheme.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    DashboardHeaderWidget(
                      farmerName: _farmerData['farmerName'] as String,
                      farmerId: _farmerData['farmerId'] as String,
                      locationAccuracy:
                          _farmerData['locationAccuracy'] as String,
                      isOnline: _isOnline,
                      lastSyncTime: _lastSyncTime,
                    ),
                    SizedBox(height: 3.h),
                    SummaryCardsWidget(
                      todayCollections: _farmerData['todayCollections'] as int,
                      pendingSyncItems: _farmerData['pendingSyncItems'] as int,
                      verifiedCollections:
                          _farmerData['verifiedCollections'] as int,
                      onTodayCollectionsTap: _navigateToHistory,
                      onPendingSyncTap: _isOnline ? _handleRefresh : null,
                      onVerifiedTap: _navigateToHistory,
                    ),
                    SizedBox(height: 4.h),
                    RecentCollectionsWidget(
                      recentCollections: _recentCollections,
                      onViewAllTap: _navigateToHistory,
                      onCollectionTap: _handleCollectionTap,
                      onViewQRCode: _handleViewQRCode,
                      onShare: _handleShare,
                      onRetrySync: _handleRetrySync,
                    ),
                    SizedBox(height: 10.h), // Space for FAB
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        width: 16.w,
        height: 16.w,
        child: FloatingActionButton(
          onPressed: _navigateToNewCollection,
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          elevation: 4.0,
          child:
              _isRefreshing
                  ? SizedBox(
                    width: 6.w,
                    height: 6.w,
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      strokeWidth: 2,
                    ),
                  )
                  : CustomIconWidget(
                    iconName: Icons.camera_alt.codePoint.toString(),
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    size: 28,
                  ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: CustomBottomBar.dashboard(
        onTap: (index) {
          // Handle navigation refresh when returning to dashboard
          if (index == 0) {
            // Dashboard selected - refresh data
            _handleRefresh();
          }
        },
      ),
    );
  }
}
