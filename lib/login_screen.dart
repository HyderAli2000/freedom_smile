import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/forget_password_screen.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/otp_verification_screen.dart';
import 'package:freedom_smile/signup_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/auth/auth_widgets.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AuthSectionTitle(
            title: 'login'.tr,
            subtitle: 'enter_credentials'.tr,
          ),
          28.verticalSpace,
          AuthInputField(
            controller: _emailController,
            hintText: 'enter_email_address'.tr,
            prefixIcon: Icons.email_rounded,
            keyboardType: TextInputType.emailAddress,
          ),
          16.verticalSpace,
          AuthInputField(
            controller: _passwordController,
            hintText: 'enter_password'.tr,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 22.w,
                height: 22.w,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() => _rememberMe = value ?? false);
                  },
                  activeColor: AppColor.whiteColor,
                  checkColor: AppColor.primaryBlue,
                  side: BorderSide(
                    color: AppColor.whiteColor.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              8.horizontalSpace,
              Text(
                'remember_me'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColor.whiteColor.withValues(alpha: 0.95),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => Get.to(() => const ForgetPasswordScreen()),
                child: Text(
                  'forgot_password'.tr,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          28.verticalSpace,
          AuthPrimaryButton(
            label: 'login'.tr,
            onPressed: () => Get.offAll(() => Navbar()),
          ),
          20.verticalSpace,
          AuthLinkText(
            prefix: 'dont_have_account'.tr,
            linkText: 'sign_up'.tr,
            onTap: () => Get.to(() => const SignUpScreen()),
            center: true,
          ),
          24.verticalSpace,
          const AuthOrDivider(),
          24.verticalSpace,
          Row(
            children: [
              Expanded(
                child: AuthSocialButton(
                  label: 'with_apple'.tr,
                  backgroundColor: AppColor.blackColor,
                  gradientColors: const [
                    Color.fromARGB(255, 44, 44, 44),
                    Color(0xff191719),
                  ],
                  leading: Image.asset(
                    AssetIcons.apple,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                  onPressed: () {},
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: AuthSocialButton(
                  label: 'with_google'.tr,
                  backgroundColor: AppColor.googleRed,
                  gradientColors: const [
                    Color.fromARGB(255, 255, 82, 63),
                    Color(0xffFF331C),
                  ],
                  leading: Image.asset(
                    AssetIcons.google,
                    width: 20.w,
                    height: 20.h,
                    fit: BoxFit.contain,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          28.verticalSpace,
          const AuthAgreementText(),
        ],
      ),
    );
  }
}
