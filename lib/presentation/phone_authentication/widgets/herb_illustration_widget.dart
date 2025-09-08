import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';

class HerbIllustrationWidget extends StatelessWidget {
  const HerbIllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60.w,
      height: 25.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
            AppTheme.lightTheme.colorScheme.secondary.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _HerbPatternPainter(),
            ),
          ),
          // Main herb illustration
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Herb leaf icon
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'eco',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 12.w,
                ),
              ),
              SizedBox(height: 2.h),
              // Brand text
              Text(
                'AyurHerb',
                style: GoogleFonts.roboto(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                'Collector',
                style: GoogleFonts.roboto(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HerbPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw subtle herb leaf patterns
    final path = Path();

    // Left side leaves
    path.moveTo(size.width * 0.2, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.25,
      size.width * 0.1,
      size.height * 0.3,
    );
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.35,
      size.width * 0.2,
      size.height * 0.3,
    );

    // Right side leaves
    path.moveTo(size.width * 0.8, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.65,
      size.width * 0.9,
      size.height * 0.7,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.75,
      size.width * 0.8,
      size.height * 0.7,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}