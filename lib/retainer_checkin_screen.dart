import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/fit_confirmation_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class RetainerCheckinScreen extends StatelessWidget {
  const RetainerCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                const PageHeader(showTitle: false),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AssetImages.teeth,
                          width: 280.w,
                          height: 280.w,
                          fit: BoxFit.contain,
                        ),
                        10.verticalSpace,
                        Text(
                          'Have you been wearing your\nretainer regularly?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textDark,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  child: Row(
                    children: [
                      Expanded(
                        child: _CheckinButton(
                          label: 'No',
                          filled: false,
                          onTap: () => Get.back(),
                        ),
                      ),
                      16.horizontalSpace,
                      Expanded(
                        child: _CheckinButton(
                          label: 'Yes',
                          filled: true,
                          onTap: () {
                            Get.to(() => const FitConfirmationScreen());
                          },
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
    );
  }
}

class _CheckinButton extends StatelessWidget {
  const _CheckinButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: filled
              ? AppColor.primaryBlue
              : AppColor.profileOptionBg.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(999999.r),
          border: Border.all(
            color: AppColor.primaryBlue,
            width: filled ? 0 : 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: filled ? AppColor.whiteColor : AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}
