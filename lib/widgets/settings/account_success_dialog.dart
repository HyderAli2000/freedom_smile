import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';

class AccountSuccessDialog extends StatelessWidget {
  const AccountSuccessDialog({
    super.key,
    required this.icon,
    required this.message,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String message;
  final String buttonLabel;
  final VoidCallback onPressed;

  static Future<void> show(
    BuildContext context, {
    required IconData icon,
    required String message,
    required String buttonLabel,
    required VoidCallback onPressed,
  }) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: message,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return AccountSuccessDialog(
          icon: icon,
          message: message,
          buttonLabel: buttonLabel,
          onPressed: onPressed,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4 * animation.value,
            sigmaY: 4 * animation.value,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 32.w),
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xffFFFFFF),
                Color.fromARGB(255, 221, 243, 255),
                Color.fromARGB(255, 190, 232, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: const BoxDecoration(
                      color: AppColor.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColor.whiteColor, size: 22.sp),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textDark,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              SizedBox(
                height: 44.h,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: AppColor.whiteColor,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9999999.r),
                    ),
                  ),
                  child: Text(
                    buttonLabel,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
