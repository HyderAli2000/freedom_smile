import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
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
  final _authService = AuthService();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _reset() async {
    final password = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    if (password.isEmpty || confirm.isEmpty) {
      ApiSnackbar.error('Please enter and confirm your new password');
      return;
    }
    if (password != confirm) {
      ApiSnackbar.error('Passwords do not match');
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await _authService.resetPassword(
        password: password,
        confirmPassword: confirm,
      );
      ApiSnackbar.success(result.message);
      Get.offAll(() => const LoginScreen());
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (e) {
      ApiSnackbar.error(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
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
            label: _loading ? '...' : 'Reset Now',
            onPressed: _loading ? () {} : _reset,
          ),
        ],
      ),
    );
  }
}
