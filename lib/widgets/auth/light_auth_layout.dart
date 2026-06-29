import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class LightAuthScaffold extends StatelessWidget {
  const LightAuthScaffold({
    super.key,
    required this.title,
    required this.child,
    this.stepText,
    this.showLogo = false,
    this.bottom,
  });

  final String title;
  final String? stepText;
  final bool showLogo;
  final Widget child;
  final Widget? bottom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _LightAuthHeader(title: title, stepText: stepText),
              if (showLogo) ...[
                12.verticalSpace,
                Image.asset(
                  AssetImages.logo,
                  height: 90.h,
                  fit: BoxFit.contain,
                ),
              ],
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
                  child: child,
                ),
              ),
              if (bottom != null) bottom!,
            ],
          ),
        ),
      ),
    );
  }
}

class _LightAuthHeader extends StatelessWidget {
  const _LightAuthHeader({required this.title, this.stepText});

  final String title;
  final String? stepText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryBlue,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryBlue, width: 1.5),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColor.primaryBlue,
                    size: 26.sp,
                  ),
                ),
              ),
              const Spacer(),
              if (stepText != null)
                Text(
                  stepText!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textBody,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class LightAuthInputField extends StatelessWidget {
  const LightAuthInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.prefixIconPath,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData prefixIconPath;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.profileOptionBg.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999999.r),
        border: Border.all(
          color: AppColor.primaryBlue.withValues(alpha: 0.35),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: AppColor.primaryBlue,
        ),
        cursorColor: AppColor.primaryBlue,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.primaryBlue.withValues(alpha: 0.55),
          ),
          prefixIcon: Icon(
            prefixIconPath,
            color: AppColor.primaryBlue,
            size: 22.sp,
          ),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 16.h,
          ),
        ),
      ),
    );
  }
}

class PermissionAccessScaffold extends StatelessWidget {
  const PermissionAccessScaffold({
    super.key,
    required this.iconPath,
    required this.title,
    required this.description,
    required this.buttonLabel,
    required this.onPressed,
  });

  final String iconPath;
  final String title;
  final String description;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 150.w,
                        height: 150.w,
                        decoration: const BoxDecoration(
                          color: AppColor.primaryBlue,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          iconPath,
                          width: 46.w,
                          height: 46.h,
                          fit: BoxFit.contain,
                        ),
                      ),
                      28.verticalSpace,
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textDark,
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textBody,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
                child: LightAuthPrimaryButton(
                  label: buttonLabel,
                  onPressed: onPressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LightAuthPrimaryButton extends StatelessWidget {
  const LightAuthPrimaryButton({
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
      height: 52.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryBlue,
          foregroundColor: AppColor.whiteColor,
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
            color: AppColor.whiteColor,
          ),
        ),
      ),
    );
  }
}
