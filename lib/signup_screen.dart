import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/agreements.dart';
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
  bool _agreeToTerms = true;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AuthSectionTitle(
            title: 'Sign Up',
            subtitle: 'Enter your Credentials',
          ),
          28.verticalSpace,
          AuthInputField(
            controller: _emailController,
            hintText: 'Email Address',
            prefixIcon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          16.verticalSpace,
          AuthInputField(
            controller: _passwordController,
            hintText: 'Password',
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
            hintText: 'Confirm Password',
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
                const TextSpan(text: 'I agree with the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.whiteColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.to(() => const AgreementsScreen()),
                ),
                const TextSpan(text: ' | '),
                TextSpan(
                  text: 'Privacy Policy',
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
            label: 'Sign up',
            onPressed: () => Get.to(
              () => OtpVerificationScreen(email: _emailController.text.trim()),
            ),
          ),
          24.verticalSpace,
          AuthLinkText(
            prefix: 'Already have an account? ',
            linkText: 'Login',
            onTap: () => Get.to(() => const LoginScreen()),
            center: true,
          ),
        ],
      ),
    );
  }
}
