import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';

class AccountSectionHeading extends StatelessWidget {
  const AccountSectionHeading({
    super.key,
    required this.title,
    this.subtitle,
  });

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
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        if (subtitle != null) ...[
          8.verticalSpace,
          Text(
            subtitle!,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
              height: 1.45,
            ),
          ),
        ],
      ],
    );
  }
}

class AccountPasswordField extends StatelessWidget {
  const AccountPasswordField({
    super.key,
    required this.label,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    required this.onToggleVisibility,
    this.helperText,
    this.errorText,
  });

  final String label;
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final VoidCallback onToggleVisibility;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textDark,
          ),
        ),
        8.verticalSpace,
        TextField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textDark,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              color: AppColor.textBody,
            ),
            filled: true,
            fillColor: AppColor.profileOptionBg.withValues(alpha: 0.85),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            prefixIcon: Icon(
              Icons.lock_rounded,
              color: AppColor.primaryBlue,
              size: 22.sp,
            ),
            suffixIcon: IconButton(
              onPressed: onToggleVisibility,
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColor.textBody,
                size: 20.sp,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColor.primaryBlue,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColor.primaryBlue,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14.r),
              borderSide: BorderSide(
                color: hasError ? Colors.red : AppColor.primaryBlue,
                width: 1.5,
              ),
            ),
          ),
        ),
        if (helperText != null) ...[
          6.verticalSpace,
          Text(
            helperText!,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
            ),
          ),
        ],
        if (hasError) ...[
          6.verticalSpace,
          Row(
            children: [
              Icon(Icons.cancel_rounded, color: Colors.red, size: 16.sp),
              6.horizontalSpace,
              Expanded(
                child: Text(
                  errorText!,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class PasswordRequirementsBox extends StatelessWidget {
  const PasswordRequirementsBox({super.key});

  static const _requirements = [
    'At least 8 characters',
    'Mix of letters and numbers',
    'At least one special character',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password must contain:',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
          10.verticalSpace,
          ..._requirements.map(
            (requirement) => Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '• ',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColor.whiteColor,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      requirement,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor.withValues(alpha: 0.95),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AccountPrimaryButton extends StatelessWidget {
  const AccountPrimaryButton({
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
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class AccountMultilineField extends StatelessWidget {
  const AccountMultilineField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      minLines: 3,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.textDark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: AppFonts.family,
          fontFamilyFallback: AppFonts.fallback,
          fontSize: 14.sp,
          color: AppColor.textBody,
        ),
        filled: true,
        fillColor: AppColor.profileOptionBg.withValues(alpha: 0.85),
        contentPadding: EdgeInsets.all(14.w),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColor.primaryBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColor.primaryBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColor.primaryBlue, width: 1.5),
        ),
      ),
    );
  }
}
