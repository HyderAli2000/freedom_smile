import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class ProfileAvatarSection extends StatelessWidget {
  const ProfileAvatarSection({
    super.key,
    required this.displayName,
    required this.email,
    this.showCamera = false,
  });

  final String displayName;
  final String email;
  final bool showCamera;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColor.primaryBlue.withValues(alpha: 0.35),
                  width: 3,
                ),
                image: DecorationImage(
                  image: AssetImage(AssetImages.p1),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (showCamera)
              Positioned(
                right: 4.w,
                bottom: 4.h,
                child: Container(
                  width: 34.w,
                  height: 34.w,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryBlue, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(7.w),
                  child: Image.asset(
                    AssetIcons.cam,
                    color: AppColor.primaryBlue,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
          ],
        ),
        16.verticalSpace,
        Text(
          displayName,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        6.verticalSpace,
        Text(
          email,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.textBody,
          ),
        ),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  const ProfileInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.showVerified = false,
    this.multiline = false,
  });

  final String label;
  final String value;
  final bool showVerified;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Row(
            crossAxisAlignment:
                multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 110.w,
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textBody,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textDark,
                          height: multiline ? 1.4 : 1.2,
                        ),
                      ),
                    ),
                    if (showVerified) ...[
                      8.horizontalSpace,
                      const ProfileVerifiedBadge(compact: true),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: AppColor.borderLightBlue.withValues(alpha: 0.5),
        ),
      ],
    );
  }
}

class ProfileVerifiedBadge extends StatelessWidget {
  const ProfileVerifiedBadge({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: compact ? 16.w : 18.w,
          height: compact ? 16.w : 18.w,
          decoration: const BoxDecoration(
            color: AppColor.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: compact ? 11.sp : 12.sp,
            color: AppColor.whiteColor,
          ),
        ),
        if (!compact) ...[
          6.horizontalSpace,
          Text(
            'Verified',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.primaryBlue,
            ),
          ),
        ],
      ],
    );
  }
}

class ProfileFormField extends StatelessWidget {
  const ProfileFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.readOnly = false,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  final TextEditingController controller;
  final String hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
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
        suffix: suffix == null
            ? null
            : Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: suffix,
              ),
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

class ProfileDropdownField extends StatelessWidget {
  const ProfileDropdownField({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColor.profileOptionBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColor.primaryBlue),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              color: AppColor.textBody,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.primaryBlue,
            size: 22.sp,
          ),
          dropdownColor: AppColor.whiteColor,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textDark,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ProfilePrimaryButton extends StatelessWidget {
  const ProfilePrimaryButton({
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
