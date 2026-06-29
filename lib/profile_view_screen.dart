import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/user_profile_data.dart';
import 'package:freedom_smile/edit_profile_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';
import 'package:get/get.dart';

class ProfileViewScreen extends StatefulWidget {
  const ProfileViewScreen({super.key, this.initialProfile});

  final UserProfile? initialProfile;

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {
  late UserProfile _profile;

  @override
  void initState() {
    super.initState();
    _profile = widget.initialProfile ?? UserProfile.sample;
  }

  Future<void> _openEditProfile() async {
    final result = await Get.to<UserProfile>(
      () => EditProfileScreen(profile: _profile),
    );
    if (result != null && mounted) {
      setState(() => _profile = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ProfileTopSection(
                displayName: _profile.displayName,
                email: _profile.profileEmail,
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                  child: _ProfileDetailsCard(profile: _profile),
                ),
              ),
              Container(
                // color: AppColor.whiteColor.withValues(alpha: 0.6),
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: ProfilePrimaryButton(
                  label: 'Edit Personal Information',
                  onPressed: _openEditProfile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileTopSection extends StatelessWidget {
  const _ProfileTopSection({required this.displayName, required this.email});

  final String displayName;
  final String email;

  @override
  Widget build(BuildContext context) {
    final avatarSize = 112.w;
    final ringWidth = 6.w;
    final avatarOverlap = avatarSize / 2;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: 180.h,
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    AppColor.whiteColor.withValues(alpha: 0.95),
                    AppColor.profileOptionBg.withValues(alpha: 0.75),
                    AppColor.profileOptionBg,
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36.r),
                  bottomRight: Radius.circular(36.r),
                ),
              ),
              child: const _ProfileViewHeader(),
            ),
            Positioned(
              bottom: -avatarOverlap,
              child: Stack(
                clipBehavior: Clip.none,
                // alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: avatarSize,
                    height: avatarSize,
                    padding: EdgeInsets.all(ringWidth),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color.fromARGB(255, 193, 193, 193),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(AssetImages.p1, fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    right: 0.w,
                    bottom: 0.h,
                    child: Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: AppColor.whiteColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColor.borderLightBlue.withValues(
                            alpha: 0.45,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8.w),
                      child: Image.asset(
                        AssetIcons.cam,
                        color: AppColor.textDark.withValues(alpha: 0.75),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: avatarOverlap + 10.h),
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
            fontWeight: FontWeight.w500,
            color: AppColor.textBody,
          ),
        ),
        16.verticalSpace,
      ],
    );
  }
}

class _ProfileViewHeader extends StatelessWidget {
  const _ProfileViewHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: 44.h,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Text(
            'Profile',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: GestureDetector(
              onTap: Get.back,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor,
                  border: Border.all(
                    color: AppColor.borderLightBlue,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColor.primaryBlue,
                  size: 24.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _ProfileDetailRow(label: 'Full Name', value: profile.fullName),
          _ProfileAddressRow(address: profile.address),
          _ProfileDetailRow(label: 'City', value: profile.city),
          _ProfileDetailRow(label: 'State', value: profile.state),
          _ProfileDetailRow(label: 'Gender', value: profile.gender),
          _ProfileVerifiedRow(label: 'Email', value: profile.email),
          _ProfileVerifiedRow(
            label: 'Phone Number',
            value: profile.formattedPhone,
            showDivider: false,
          ),
        ],
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textBody,
                  ),
                ),
              ),
            ],
          ),
        ),
        _ProfileRowDivider(),
      ],
    );
  }
}

class _ProfileAddressRow extends StatelessWidget {
  const _ProfileAddressRow({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
              8.verticalSpace,
              Text(
                address,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textBody,
                  height: 1.45,
                ),
              ),
            ],
          ),
        ),
        _ProfileRowDivider(),
      ],
    );
  }
}

class _ProfileVerifiedRow extends StatelessWidget {
  const _ProfileVerifiedRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
              const Spacer(),
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 18.w,
                      height: 18.w,
                      decoration: const BoxDecoration(
                        color: AppColor.primaryBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_rounded,
                        color: AppColor.whiteColor,
                        size: 12.sp,
                      ),
                    ),
                    4.horizontalSpace,
                    Flexible(
                      child: Text(
                        value,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColor.textBody,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (showDivider) _ProfileRowDivider(),
      ],
    );
  }
}

class _ProfileRowDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16.w,
      endIndent: 16.w,
      color: AppColor.borderLightBlue.withValues(alpha: 0.45),
    );
  }
}
