import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/otp_verification_forgot.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _emailController = TextEditingController();
  final _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ApiSnackbar.error('Please enter your email');
      return;
    }
    setState(() => _loading = true);
    try {
      final result = await _authService.forgotPassword(email: email);
      ApiSnackbar.success(result.message);
      Get.to(
        () => OtpVerificationForgot(email: email, isForgotPassword: true),
      );
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
            label: _loading ? '...' : 'Continue',
            onPressed: _loading ? () {} : _continue,
          ),
        ],
      ),
    );
  }
}
