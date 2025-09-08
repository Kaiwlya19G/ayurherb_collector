import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/herb_illustration_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/otp_verification_widget.dart';
import './widgets/phone_input_widget.dart';
import './widgets/send_otp_button_widget.dart';
import 'widgets/herb_illustration_widget.dart';
import 'widgets/language_selector_widget.dart';
import 'widgets/otp_verification_widget.dart';
import 'widgets/phone_input_widget.dart';
import 'widgets/send_otp_button_widget.dart';

class PhoneAuthentication extends StatefulWidget {
  const PhoneAuthentication({super.key});

  @override
  State<PhoneAuthentication> createState() => _PhoneAuthenticationState();
}

class _PhoneAuthenticationState extends State<PhoneAuthentication>
    with TickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedLanguage = 'en';
  String? _phoneError;
  bool _isLoading = false;
  bool _showOtpSheet = false;
  bool _isVerifying = false;

  late AnimationController _fadeController;
  late AnimationController _scaleController;

  // Mock credentials for testing
  final Map<String, Map<String, String>> _mockCredentials = {
    '9876543210': {'otp': '123456', 'farmerId': 'FARM001'},
    '8765432109': {'otp': '654321', 'farmerId': 'FARM002'},
    '7654321098': {'otp': '111111', 'farmerId': 'FARM003'},
  };

  Map<String, String> get _titles => {
        'en': 'Welcome to AyurHerb',
        'hi': 'AyurHerb में आपका स्वागत है',
        'mr': 'AyurHerb मध्ये आपले स्वागत आहे',
      };

  Map<String, String> get _subtitles => {
        'en': 'Secure blockchain-based herb collection tracking',
        'hi': 'सुरक्षित ब्लॉकचेन-आधारित जड़ी-बूटी संग्रह ट्रैकिंग',
        'mr': 'सुरक्षित ब्लॉकचेन-आधारित औषधी संकलन ट्रैकिंग',
      };

  Map<String, String> get _phoneErrors => {
        'en': 'Please enter a valid 10-digit mobile number',
        'hi': 'कृपया एक वैध 10-अंकीय मोबाइल नंबर दर्ज करें',
        'mr': 'कृपया वैध 10-अंकी मोबाइल नंबर टाका',
      };

  Map<String, String> get _otpErrors => {
        'en': 'Invalid OTP. Please try again.',
        'hi': 'गलत OTP। कृपया पुनः प्रयास करें।',
        'mr': 'चुकीचा OTP. कृपया पुन्हा प्रयत्न करा.',
      };

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    return _phoneController.text.length == 10 &&
        RegExp(r'^[6-9]\d{9}$').hasMatch(_phoneController.text);
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phoneError = null;
    });
  }

  void _onLanguageChanged(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _sendOtp() async {
    if (!_isPhoneValid) {
      setState(() {
        _phoneError = _phoneErrors[_selectedLanguage] ?? _phoneErrors['en']!;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _phoneError = null;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _showOtpSheet = true;
      });

      // Show OTP bottom sheet
      _showOtpBottomSheet();
    }
  }

  void _showOtpBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OtpVerificationWidget(
        phoneNumber: _phoneController.text,
        selectedLanguage: _selectedLanguage,
        onOtpCompleted: _verifyOtp,
        onResendOtp: _resendOtp,
        isVerifying: _isVerifying,
      ),
    ).then((_) {
      setState(() {
        _showOtpSheet = false;
        _isVerifying = false;
      });
    });
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isVerifying = true;
    });

    // Simulate OTP verification
    await Future.delayed(Duration(seconds: 2));

    final phoneNumber = _phoneController.text;
    final mockData = _mockCredentials[phoneNumber];

    if (mockData != null && mockData['otp'] == otp) {
      // Success - trigger haptic feedback
      HapticFeedback.lightImpact();

      // Navigate to dashboard
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/collection-dashboard',
          (route) => false,
        );
      }
    } else {
      // Show error
      if (mounted) {
        setState(() {
          _isVerifying = false;
        });

        Navigator.pop(context); // Close OTP sheet

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _otpErrors[_selectedLanguage] ?? _otpErrors['en']!,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            margin: EdgeInsets.all(4.w),
          ),
        );
      }
    }
  }

  Future<void> _resendOtp() async {
    // Simulate resend OTP
    await Future.delayed(Duration(seconds: 1));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'OTP sent successfully',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.all(4.w),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    final scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 90.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Language selector
                    Align(
                      alignment: Alignment.topRight,
                      child: LanguageSelectorWidget(
                        selectedLanguage: _selectedLanguage,
                        onLanguageChanged: _onLanguageChanged,
                      ),
                    ),
                    SizedBox(height: 4.h),

                    // Herb illustration
                    HerbIllustrationWidget(),
                    SizedBox(height: 4.h),

                    // Title and subtitle
                    Text(
                      _titles[_selectedLanguage] ?? _titles['en']!,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        letterSpacing: 0.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 1.h),

                    Text(
                      _subtitles[_selectedLanguage] ?? _subtitles['en']!,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 6.h),

                    // Phone input
                    PhoneInputWidget(
                      controller: _phoneController,
                      errorText: _phoneError,
                      onChanged: _onPhoneChanged,
                      selectedLanguage: _selectedLanguage,
                    ),
                    SizedBox(height: 4.h),

                    // Send OTP button
                    SendOtpButtonWidget(
                      isEnabled: _isPhoneValid,
                      isLoading: _isLoading,
                      onPressed: _sendOtp,
                      selectedLanguage: _selectedLanguage,
                    ),
                    SizedBox(height: 4.h),

                    // Trust signals
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'verified_user',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 20,
                          ),
                          SizedBox(width: 3.w),
                          Expanded(
                            child: Text(
                              _selectedLanguage == 'hi'
                                  ? 'सुरक्षित और एन्क्रिप्टेड डेटा हैंडलिंग'
                                  : _selectedLanguage == 'mr'
                                      ? 'सुरक्षित आणि एन्क्रिप्टेड डेटा हँडलिंग'
                                      : 'Secure and encrypted data handling',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
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
      ),
    );
  }
}