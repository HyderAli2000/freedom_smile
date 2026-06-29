import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/location_access_screen.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LightAuthScaffold(
      title: 'Reset Password',
      showLogo: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          32.verticalSpace,
          LightAuthInputField(
            controller: _newPasswordController,
            hintText: 'New Password',
            prefixIconPath: Icons.lock_rounded,
            obscureText: _obscureNewPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscureNewPassword = !_obscureNewPassword);
              },
              icon: Icon(
                _obscureNewPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.textBody,
                size: 20.sp,
              ),
            ),
          ),
          16.verticalSpace,
          LightAuthInputField(
            controller: _confirmPasswordController,
            hintText: 'Confirm New Password',
            prefixIconPath: Icons.lock_rounded,
            obscureText: _obscureConfirmPassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                );
              },
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.textBody,
                size: 20.sp,
              ),
            ),
          ),
          28.verticalSpace,
          LightAuthPrimaryButton(
            label: 'Reset Now',
            onPressed: () => Get.offAll(() => const LoginScreen()),
          ),
        ],
      ),
    );
  }
}
