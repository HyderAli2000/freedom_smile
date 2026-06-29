import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/re_evaluation_map_user.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class ReEvaluationDialog extends StatelessWidget {
  const ReEvaluationDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Re-Evaluation Recommended',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const ReEvaluationDialog();
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
          margin: EdgeInsets.symmetric(horizontal: 28.w),
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            gradient: LinearGradient(
              colors: [
                Color(0xffFFFFFF),
                Color.fromARGB(255, 221, 243, 255),
                Color.fromARGB(255, 190, 232, 255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Re-Evaluation Recommended',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.blackColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close_rounded,
                      size: 22.sp,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
              24.verticalSpace,
              Container(
                width: 88.w,
                height: 88.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.profileOptionBg,
                  border: Border.all(color: AppColor.primaryBlue, width: 1),
                ),
                padding: EdgeInsets.all(18.w),
                child: Image.asset(AssetIcons.teeth1, fit: BoxFit.contain),
              ),
              20.verticalSpace,
              Text(
                'We Suggest you to visit your nearest Orthodontist, you can schedule appointment through the app',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                  height: 1.5,
                ),
              ),
              28.verticalSpace,
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Get.to(() => const ReEvaluationMapUser());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: AppColor.whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.whiteColor,
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
