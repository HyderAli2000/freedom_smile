import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/create_profile.dart';
import 'package:freedom_smile/reset_password_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationForgot extends StatefulWidget {
  const OtpVerificationForgot({
    super.key,
    required this.email,
    this.isForgotPassword = false,
  });

  final String email;
  final bool isForgotPassword;

  @override
  State<OtpVerificationForgot> createState() => _OtpVerificationForgotState();
}

class _OtpVerificationForgotState extends State<OtpVerificationForgot> {
  final CountDownController _controller = CountDownController();

  Timer? _timer;
  // ignore: unused_field
  bool _showResendOption = false;
  bool complete = false;
  final int _duration = 30;
  bool _openedNext = false;

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  void _startProgress() {
    const totalDuration = 3;
    const updateInterval = 50;
    const totalSteps = (totalDuration * 60) ~/ updateInterval;
    var currentPercent = 0.0;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: updateInterval), (
      timer,
    ) {
      if (!mounted) return;
      if (currentPercent < 0.95) {
        currentPercent += 0.01 / totalSteps;
      } else {
        timer.cancel();
        setState(() => _showResendOption = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpCompleted(String pin) {
    if (_openedNext) return;
    _openedNext = true;
    FocusScope.of(context).unfocus();

    if (widget.isForgotPassword) {
      Get.to(() => const ResetPasswordScreen());
      return;
    }

    Get.to(
      () => CreateProfileScreen(prefillEmail: widget.email, isEdit: false),
    );
  }

  void _onResend() {
    setState(() {
      _controller.start();
      complete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusScope.of(context).unfocus(),
      child: LightAuthScaffold(
        title: 'OTP Verification',
        showLogo: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            16.verticalSpace,
            Text(
              'We have sent you an email containing 6 digits verification code. Please enter the code to verify your identity',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textBody,
                height: 1.45,
              ),
            ),
            28.verticalSpace,
            PinCodeTextField(
              appContext: context,
              length: 6,
              keyboardType: TextInputType.number,
              enableActiveFill: true,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.circle,
                fieldHeight: 52.h,
                fieldWidth: 45.w,
                borderWidth: 1,
                inactiveBorderWidth: 1,
                activeBorderWidth: 1,
                selectedBorderWidth: 2,
                inactiveFillColor: AppColor.profileOptionBg.withValues(
                  alpha: 0.85,
                ),
                inactiveColor: AppColor.primaryBlue.withValues(alpha: 0.35),
                activeFillColor: AppColor.profileOptionBg,
                activeColor: AppColor.primaryBlue,
                selectedFillColor: AppColor.profileOptionBg,
                selectedColor: AppColor.primaryBlue,
              ),
              cursorColor: AppColor.primaryBlue,
              textStyle: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryBlue,
              ),
              onCompleted: _onOtpCompleted,
              onChanged: (_) {},
            ),
            40.verticalSpace,
            Center(
              child: SizedBox(
                height: 150.h,
                width: 150.w,
                child: CircularCountDownTimer(
                  duration: _duration,
                  initialDuration: 0,
                  controller: _controller,
                  width: 124.w,
                  height: 124.h,
                  ringColor: Colors.transparent,
                  fillColor: AppColor.primaryBlue,
                  backgroundColor: AppColor.whiteColor,
                  strokeWidth: 6.0,
                  strokeCap: StrokeCap.round,
                  textStyle: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 18.sp,
                    color: AppColor.primaryBlue,
                    fontWeight: FontWeight.bold,
                  ),
                  textFormat: CountdownTextFormat.MM_SS,
                  isReverse: true,
                  isReverseAnimation: true,
                  isTimerTextShown: true,
                  autoStart: true,
                  onComplete: () {
                    if (mounted) {
                      setState(() => complete = true);
                    }
                  },
                  onChange: (_) {},
                ),
              ),
            ),
            40.verticalSpace,
            if (complete)
              GestureDetector(
                onTap: _onResend,
                child: Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 14.sp,
                      color: AppColor.textBody,
                    ),
                    children: [
                      const TextSpan(text: "Didn't received the code?  "),
                      TextSpan(
                        text: 'Resend',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.primaryBlue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColor.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
