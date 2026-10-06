import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/fit_confirmation_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

/// Screen 1 — Order Now / daily fit-check entry.
/// Yes or No both continue to Fit Confirmation (screen 2).
class RetainerCheckinScreen extends StatefulWidget {
  const RetainerCheckinScreen({
    super.key,
    this.isOrderFlow = false,
  });

  /// True when opened from Order Now on Home/Retainers.
  final bool isOrderFlow;

  @override
  State<RetainerCheckinScreen> createState() => _RetainerCheckinScreenState();
}

class _RetainerCheckinScreenState extends State<RetainerCheckinScreen> {
  void _answer({required bool wearsRegularly}) {
    Get.to(
      () => FitConfirmationScreen(
        wearsRegularly: wearsRegularly,
        isOrderFlow: widget.isOrderFlow,
      ),
    );
  }

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
                        onTap: () => _answer(wearsRegularly: false),
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: _CheckinButton(
                        label: 'Yes',
                        filled: true,
                        onTap: () => _answer(wearsRegularly: true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
