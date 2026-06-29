import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/create_profile.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/widgets/auth/auth_widgets.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({
    super.key,
    required this.email,
    this.isForgotPassword = false,
  });

  final String email;
  final bool isForgotPassword;

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final CountDownController _controller = CountDownController();

  double _currentPercent = 0.0;
  Timer? _timer;
  // ignore: unused_field
  bool _showResendOption = false;
  bool complete = false;
  final int _duration = 30;
  bool _openedProfile = false;

  void startProgress() {
    _currentPercent = 0.0;
    _showResendOption = false;

    const totalDuration = 3;
    const updateInterval = 50;
    const totalSteps = (totalDuration * 60) ~/ updateInterval;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: updateInterval), (
      timer,
    ) {
      if (!mounted) return;
      if (_currentPercent < 0.95) {
        setState(() {
          _currentPercent += 0.01 / totalSteps;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _showResendOption = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startProgress();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onOtpCompleted(String pin) {
    if (_openedProfile) return;
    _openedProfile = true;
    FocusScope.of(context).unfocus();

    if (widget.isForgotPassword) {
      // TODO: Navigate to reset password screen.
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
      child: AuthLayout(
        headerTitle: 'OTP Verification',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthSectionTitle(
              title: 'OTP Verification',
              subtitle:
                  'We have sent you an email containing 6 digits verification code. Please enter the code to verify your identity',
            ),
            32.verticalSpace,
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
                inactiveFillColor: Colors.transparent,
                inactiveColor: AppColor.whiteColor.withValues(alpha: 0.55),
                activeFillColor: Colors.transparent,
                activeColor: AppColor.whiteColor,
                selectedFillColor: Colors.transparent,
                selectedColor: AppColor.whiteColor,
              ),
              cursorColor: AppColor.whiteColor,
              textStyle: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.whiteColor,
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
                  fillColor: AppColor.whiteColor.withValues(alpha: 0.55),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 20.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _onResend,
                      child: Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 14.sp,
                            color: AppColor.whiteColor.withValues(alpha: 0.9),
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
                                color: AppColor.whiteColor,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColor.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
