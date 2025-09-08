import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class OtpVerificationWidget extends StatefulWidget {
  final String phoneNumber;
  final String selectedLanguage;
  final Function(String) onOtpCompleted;
  final VoidCallback onResendOtp;
  final bool isVerifying;

  const OtpVerificationWidget({
    super.key,
    required this.phoneNumber,
    required this.selectedLanguage,
    required this.onOtpCompleted,
    required this.onResendOtp,
    required this.isVerifying,
  });

  @override
  State<OtpVerificationWidget> createState() => _OtpVerificationWidgetState();
}

class _OtpVerificationWidgetState extends State<OtpVerificationWidget>
    with TickerProviderStateMixin {
  final TextEditingController _otpController = TextEditingController();
  late AnimationController _timerController;
  late AnimationController _slideController;
  int _resendTimer = 30;

  Map<String, String> get _titles => {
        'en': 'Verify Phone Number',
        'hi': 'फ़ोन नंबर सत्यापित करें',
        'mr': 'फोन नंबर सत्यापित करा',
      };

  Map<String, String> get _subtitles => {
        'en': 'Enter the 6-digit code sent to',
        'hi': 'भेजे गए 6-अंकीय कोड को दर्ज करें',
        'mr': '6-अंकी कोड टाका जो पाठवला आहे',
      };

  Map<String, String> get _resendTexts => {
        'en': 'Resend OTP',
        'hi': 'OTP पुनः भेजें',
        'mr': 'OTP पुन्हा पाठवा',
      };

  Map<String, String> get _verifyingTexts => {
        'en': 'Verifying...',
        'hi': 'सत्यापित कर रहे हैं...',
        'mr': 'सत्यापित करत आहे...',
      };

  @override
  void initState() {
    super.initState();
    _timerController = AnimationController(
      duration: Duration(seconds: 30),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _startTimer();
    _slideController.forward();
  }

  @override
  void dispose() {
    _timerController.dispose();
    _slideController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _resendTimer = 30;
    _timerController.reset();
    _timerController.forward();

    _timerController.addListener(() {
      if (mounted) {
        setState(() {
          _resendTimer = (30 * (1 - _timerController.value)).round();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final slideAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    return SlideTransition(
      position: slideAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.lightTheme.shadowColor.withValues(alpha: 0.2),
              offset: Offset(0, -4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Handle bar
                Container(
                  width: 12.w,
                  height: 0.5.h,
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 3.h),

                // Title
                Text(
                  _titles[widget.selectedLanguage] ?? _titles['en']!,
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),

                // Subtitle with phone number
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.roboto(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.7),
                    ),
                    children: [
                      TextSpan(
                        text: _subtitles[widget.selectedLanguage] ??
                            _subtitles['en']!,
                      ),
                      TextSpan(text: '\n'),
                      TextSpan(
                        text: '+91 ${widget.phoneNumber}',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),

                // OTP Input
                Pinput(
                  controller: _otpController,
                  length: 6,
                  autofocus: true,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: widget.onOtpCompleted,
                  defaultPinTheme: PinTheme(
                    width: 12.w,
                    height: 6.h,
                    textStyle: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 12.w,
                    height: 6.h,
                    textStyle: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.2),
                          offset: Offset(0, 2),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 12.w,
                    height: 6.h,
                    textStyle: GoogleFonts.roboto(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 4.h),

                // Verification status or resend button
                widget.isVerifying
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.colorScheme.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            _verifyingTexts[widget.selectedLanguage] ??
                                _verifyingTexts['en']!,
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _resendTimer > 0
                                ? 'Resend in ${_resendTimer}s'
                                : _resendTexts[widget.selectedLanguage] ??
                                    _resendTexts['en']!,
                            style: GoogleFonts.roboto(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: _resendTimer > 0
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.6)
                                  : AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                          if (_resendTimer == 0) ...[
                            SizedBox(width: 2.w),
                            GestureDetector(
                              onTap: () {
                                widget.onResendOtp();
                                _startTimer();
                              },
                              child: CustomIconWidget(
                                iconName: 'refresh',
                                color: AppTheme.lightTheme.colorScheme.primary,
                                size: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                SizedBox(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}