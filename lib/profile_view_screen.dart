import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/user_profile_data.dart';
import 'package:freedom_smile/edit_profile_screen.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
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
      backgroundColor: Colors.white,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: const PageHeader(
                  title: 'Profile',
                  whiteBackButton: true,
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                  child: Column(
                    children: [
                      ProfileAvatarSection(
                        displayName: _profile.displayName,
                        email: _profile.profileEmail,
                      ),
                      28.verticalSpace,
                      ProfileInfoRow(
                        label: 'Full Name',
                        value: _profile.fullName,
                      ),
                      ProfileInfoRow(
                        label: 'Address',
                        value: _profile.address,
                        multiline: true,
                      ),
                      ProfileInfoRow(label: 'City', value: _profile.city),
                      ProfileInfoRow(label: 'State', value: _profile.state),
                      ProfileInfoRow(label: 'Gender', value: _profile.gender),
                      ProfileInfoRow(
                        label: 'Email',
                        value: _profile.email,
                        showVerified: true,
                      ),
                      ProfileInfoRow(
                        label: 'Phone Number',
                        value: _profile.formattedPhone,
                        showVerified: true,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
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
