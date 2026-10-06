import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/agreements.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:freedom_smile/otp_verification_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/widgets/auth/auth_widgets.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _agreeToTerms = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      ApiSnackbar.error('Please enter email and password');
      return;
    }
    if (password != confirm) {
      ApiSnackbar.error('Passwords do not match');
      return;
    }
    if (!_agreeToTerms) {
      ApiSnackbar.error('Please accept Terms & Privacy Policy');
      return;
    }

    setState(() => _loading = true);
    try {
      final result = await _authService.signup(
        email: email,
        password: password,
        termsAccepted: _agreeToTerms,
      );
      ApiSnackbar.success(result.message);
      Get.to(() => OtpVerificationScreen(email: email));
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
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthSectionTitle(
            title: 'sign_up_title'.tr,
            subtitle: 'enter_credentials'.tr,
          ),
          28.verticalSpace,
          AuthInputField(
            controller: _emailController,
            hintText: 'email_address'.tr,
            prefixIcon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          16.verticalSpace,
          AuthInputField(
            controller: _passwordController,
            hintText: 'password'.tr,
            prefixIcon: Icons.lock_rounded,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.whiteColor.withValues(alpha: 0.85),
                size: 22.sp,
              ),
            ),
          ),
          16.verticalSpace,
          AuthInputField(
            controller: _confirmPasswordController,
            hintText: 'confirm_password'.tr,
            prefixIcon: Icons.lock_rounded,
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
                color: AppColor.whiteColor.withValues(alpha: 0.85),
                size: 22.sp,
              ),
            ),
          ),
          20.verticalSpace,
          AuthCheckboxTile(
            value: _agreeToTerms,
            onChanged: (value) {
              setState(() => _agreeToTerms = value ?? false);
            },
            richLabel: TextSpan(
              children: [
                TextSpan(text: 'agree_with_terms_prefix'.tr),
                TextSpan(
                  text: 'terms_and_conditions'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.whiteColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const AgreementsScreen()),
                ),
                TextSpan(text: 'terms_privacy_separator'.tr),
                TextSpan(
                  text: 'privacy_policy'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.whiteColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const AgreementsScreen()),
                ),
              ],
            ),
          ),
          28.verticalSpace,
          AuthPrimaryButton(
            label: _loading ? '...' : 'sign_up_button'.tr,
            onPressed: _loading ? () {} : _signup,
          ),
          24.verticalSpace,
          AuthLinkText(
            prefix: 'already_have_account'.tr,
            linkText: 'login'.tr,
            onTap: () => Get.to(() => const LoginScreen()),
            center: true,
          ),
        ],
      ),
    );
  }
}
