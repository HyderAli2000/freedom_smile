import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/location_access_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

/// Onboarding step 5/5 — enter a referral code.
class ReferralOnboardingScreen extends StatefulWidget {
  const ReferralOnboardingScreen({super.key});

  @override
  State<ReferralOnboardingScreen> createState() =>
      _ReferralOnboardingScreenState();
}

class _ReferralOnboardingScreenState extends State<ReferralOnboardingScreen> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onSkip() {
    Get.back();
  }

  void _onApplyCode() {
    Get.to(() => const LocationAccessScreen());
  }

  @override
  Widget build(BuildContext context) {
    return LightAuthScaffold(
      title: 'Referral',
      stepText: 'Step 5/5',
      bottom: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textBody,
                ),
                children: [
                  const TextSpan(text: "Don't have one? "),
                  TextSpan(
                    text: 'Skip',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.primaryBlue,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = _onSkip,
                  ),
                ],
              ),
            ),
            16.verticalSpace,
            LightAuthPrimaryButton(
              label: 'Apply Code',
              onPressed: _onApplyCode,
            ),
          ],
        ),
      ),
      child: Column(
        children: [
          24.verticalSpace,
          Container(
            width: 100.w,
            height: 100.w,
            decoration: const BoxDecoration(
              color: AppColor.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.card_giftcard_rounded,
              color: AppColor.whiteColor,
              size: 46.sp,
            ),
          ),
          28.verticalSpace,
          Text(
            'Got a Referral Code?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),
          12.verticalSpace,
          Text(
            'Enter a code to unlock exclusive\nrewards and benefits.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.textBody,
              height: 1.45,
            ),
          ),
          32.verticalSpace,
          LightAuthInputField(
            controller: _codeController,
            hintText: 'Enter Code',
            prefixIconPath: Icons.code_rounded,
          ),
        ],
      ),
    );
  }
}
