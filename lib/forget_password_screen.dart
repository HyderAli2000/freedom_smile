import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/otp_verification_forgot.dart';
import 'package:freedom_smile/otp_verification_screen.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightAuthScaffold(
      title: 'Forget Password',
      showLogo: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          32.verticalSpace,
          LightAuthInputField(
            controller: _emailController,
            hintText: 'Email Address',
            prefixIconPath: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          24.verticalSpace,
          LightAuthPrimaryButton(
            label: 'Continue',
            onPressed: () {
              Get.to(
                () => OtpVerificationForgot(
                  email: _emailController.text.trim(),
                  isForgotPassword: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
