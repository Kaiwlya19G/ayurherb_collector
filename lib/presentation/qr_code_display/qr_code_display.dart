import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_buttons_widget.dart';
import './widgets/blockchain_status_widget.dart';
import './widgets/collection_details_card.dart';
import './widgets/qr_code_widget.dart';

class QrCodeDisplay extends StatefulWidget {
  const QrCodeDisplay({super.key});

  @override
  State<QrCodeDisplay> createState() => _QrCodeDisplayState();
}

class _QrCodeDisplayState extends State<QrCodeDisplay>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool _isOnline = true;
  bool _isLoading = false;

  // Mock collection data
  final Map<String, dynamic> _collectionData = {
    "collectionId": "AHC-2025-001234",
    "herbSpecies": "अश्वगंधा (Ashwagandha)",
    "quantity": 15.75,
    "collectionDate": DateTime(2025, 1, 5, 8, 30),
    "farmerId": "FRM-MH-2024-5678",
    "latitude": 19.0760,
    "longitude": 72.8777,
    "transactionId": "0x1a2b3c4d5e6f7890abcdef1234567890",
    "blockchainStatus": "verified",
    "lastVerified": DateTime.now().subtract(Duration(minutes: 15)),
    "qrData":
        "AHC-2025-001234|अश्वगंधा|15.75|05/01/2025|FRM-MH-2024-5678|19.0760,72.8777|0x1a2b3c4d5e6f7890abcdef1234567890",
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkConnectivity();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _scaleController.forward();
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

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context),
      body:
          _isLoading ? _buildLoadingState(context) : _buildMainContent(context),
      bottomNavigationBar: CustomBottomBar.qrCode(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      title: Text('QR Code Display', style: theme.appBarTheme.titleTextStyle),
      centerTitle: true,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'close',
          color:
              theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed:
            () => Navigator.pushNamedAndRemoveUntil(
              context,
              '/collection-dashboard',
              (route) => false,
            ),
        tooltip: 'Close',
      ),
      actions: [
        IconButton(
          icon: CustomIconWidget(
            iconName: 'qr_code_scanner',
            color:
                theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: _handleScanPressed,
          tooltip: 'Scan QR Code',
        ),
        SizedBox(width: 2.w),
      ],
      elevation: 2,
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.primaryColor),
          SizedBox(height: 4.h),
          Text(
            'Loading QR Code...',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Connection status indicator
                    if (!_isOnline) _buildOfflineIndicator(context),

                    SizedBox(height: 2.h),

                    // QR Code with animation
                    AnimatedBuilder(
                      animation: _scaleAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: GestureDetector(
                            onTap: _handleQrCodeTap,
                            child: QrCodeWidget(
                              qrData:
                                  (_collectionData['qrData'] as String?) ?? '',
                              size: 70.w,
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Blockchain status
                    BlockchainStatusWidget(
                      status:
                          (_collectionData['blockchainStatus'] as String?) ??
                          'pending',
                      lastVerified:
                          _collectionData['lastVerified'] as DateTime?,
                      isOnline: _isOnline,
                    ),

                    SizedBox(height: 2.h),

                    // Collection details
                    CollectionDetailsCard(collectionData: _collectionData),

                    SizedBox(height: 3.h),

                    // Action buttons
                    ActionButtonsWidget(
                      qrData: (_collectionData['qrData'] as String?) ?? '',
                      collectionData: _collectionData,
                      onScanPressed: _handleScanPressed,
                      onDownloadPressed: _handleDownloadPressed,
                    ),

                    SizedBox(height: 2.h),

                    // Instructions text
                    _buildInstructionsText(context),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOfflineIndicator(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.getWarningColor(
          theme.brightness == Brightness.light,
        ).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.w),
        border: Border.all(
          color: AppTheme.getWarningColor(
            theme.brightness == Brightness.light,
          ).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'wifi_off',
            color: AppTheme.getWarningColor(
              theme.brightness == Brightness.light,
            ),
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              'Offline Mode - QR code cached locally',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.getWarningColor(
                  theme.brightness == Brightness.light,
                ),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsText(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12.w),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'info',
                color: theme.colorScheme.primary,
                size: 20,
              ),
              SizedBox(width: 2.w),
              Text(
                'Instructions',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            '• Share this QR code with buyers for traceability verification\n'
            '• Download high-resolution version for printing on packaging\n'
            '• Tap QR code to zoom for better visibility\n'
            '• Use scanner to verify other collection codes',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  void _handleQrCodeTap() {
    HapticFeedback.lightImpact();
    // Show zoom dialog or navigate to full-screen view
    _showQrCodeZoomDialog();
  }

  void _showQrCodeZoomDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                child: QrCodeWidget(
                  qrData: (_collectionData['qrData'] as String?) ?? '',
                  size: 80.w,
                ),
              ),
            ),
          ),
    );
  }

  void _handleScanPressed() {
    HapticFeedback.lightImpact();
    // Navigate to QR scanner or show scanner overlay
    Navigator.pushNamed(context, '/qr-scanner');
  }

  void _handleDownloadPressed() {
    HapticFeedback.lightImpact();
    // Trigger download functionality
    setState(() {
      _isLoading = true;
    });

    Future.delayed(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }
}
