import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/referral_onboarding_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:get/get.dart';

class ReminderSetDialog extends StatelessWidget {
  const ReminderSetDialog({
    super.key,
    this.onContinue,
  });

  final VoidCallback? onContinue;

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onContinue,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ReminderSetDialog(onContinue: onContinue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Spacer(),
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
            Text(
              'Daily Reminder Is Set',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
              ),
            ),
            24.verticalSpace,
            Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.borderLightBlue,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.check_rounded,
                size: 40.sp,
                color: AppColor.textBody,
              ),
            ),
            20.verticalSpace,
            Text(
              "You're all set! We'll remind you every day to keep your smile healthy and on track.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textBody,
                height: 1.5,
              ),
            ),
            28.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (onContinue != null) {
                    onContinue!();
                  } else {
                    Get.to(() => const ReferralOnboardingScreen());
                  }
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
    );
  }
}
