import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/agreements.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class AuthLayout extends StatelessWidget {
  const AuthLayout({super.key, this.headerTitle, required this.child});

  final String? headerTitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      _AuthBackButton(onBack: Get.back),

                      if (headerTitle != null) ...[
                        Expanded(
                          child: Center(
                            child: Text(
                              textAlign: TextAlign.center,
                              headerTitle!,
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w500,
                                color: AppColor.textDark,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  16.verticalSpace,
                  Image.asset(
                    AssetImages.logo,
                    height: 110.h,
                    width: 240.w,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
            ),
            20.verticalSpace,
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40.r),
                    topRight: Radius.circular(40.r),
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 24.h),
                  child: child,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthBackButton extends StatelessWidget {
  const _AuthBackButton({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: onBack,
        child: Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColor.primaryBlue, width: 1.5),
          ),
          child: Icon(
            Icons.chevron_left_rounded,
            color: AppColor.primaryBlue,
            size: 28.sp,
          ),
        ),
      ),
    );
  }
}

class AuthSectionTitle extends StatelessWidget {
  const AuthSectionTitle({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.whiteColor,
          ),
        ),
        if (subtitle != null) ...[
          8.verticalSpace,
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ],
    );
  }
}

class AuthInputField extends StatelessWidget {
  const AuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon = Icons.email_outlined,
    this.obscureText = false,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999999.r),
        border: Border.all(
          color: AppColor.whiteColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColor.whiteColor,
        ),
        cursorColor: AppColor.whiteColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.whiteColor.withValues(alpha: 0.65),
          ),
          prefixIcon: Icon(
            prefixIcon,
            color: AppColor.whiteColor.withValues(alpha: 0.85),
            size: 22.sp,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
        ),
      ),
    );
  }
}

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.whiteColor,
          foregroundColor: AppColor.primaryBlue,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.buttonTextClr,
          ),
        ),
      ),
    );
  }
}

class AuthOrDivider extends StatelessWidget {
  const AuthOrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Divider(
            color: AppColor.whiteColor.withValues(alpha: 0.45),
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Or',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor.withValues(alpha: 0.9),
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: AppColor.whiteColor.withValues(alpha: 0.45),
            thickness: 1,
          ),
        ),
      ],
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.leading,
    required this.onPressed,
    this.gradientColors,
  });

  final String label;
  final Color backgroundColor;
  final List<Color>? gradientColors;
  final Widget leading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors =
        gradientColors ??
        [
          backgroundColor,
          Color.lerp(backgroundColor, AppColor.whiteColor, 0.18)!,
        ];

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 50.h,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999999.r),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: colors,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leading,
            8.horizontalSpace,
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AuthLinkText extends StatelessWidget {
  const AuthLinkText({
    super.key,
    required this.prefix,
    required this.linkText,
    required this.onTap,
    this.center = false,
  });

  final String prefix;
  final String linkText;
  final VoidCallback onTap;
  final bool center;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColor.whiteColor.withValues(alpha: 0.95),
        ),
        children: [
          TextSpan(text: prefix),
          TextSpan(
            text: linkText,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
              decorationColor: AppColor.whiteColor,
            ),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
        ],
      ),
      textAlign: center ? TextAlign.center : TextAlign.start,
    );
  }
}

class AuthAgreementText extends StatelessWidget {
  const AuthAgreementText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'By signing up you agree to our ',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.whiteColor.withValues(alpha: 0.9),
          ),
        ),
        8.verticalSpace,
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Terms & Conditions',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.whiteColor.withValues(alpha: 0.9),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.to(() => const AgreementsScreen()),
              ),
              const TextSpan(text: ' | '),
              TextSpan(
                text: 'Privacy Policy',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.whiteColor.withValues(alpha: 0.9),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Get.to(() => const AgreementsScreen()),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class AuthCheckboxTile extends StatelessWidget {
  const AuthCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.richLabel,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final InlineSpan? richLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22.w,
          height: 22.w,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
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
        10.horizontalSpace,
        Expanded(
          child: richLabel != null
              ? Text.rich(
                  TextSpan(
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.whiteColor.withValues(alpha: 0.95),
                      height: 1.4,
                    ),
                    children: [richLabel!],
                  ),
                )
              : Text(
                  label ?? '',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.whiteColor.withValues(alpha: 0.95),
                  ),
                ),
        ),
      ],
    );
  }
}
