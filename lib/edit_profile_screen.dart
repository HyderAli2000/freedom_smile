import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/user_profile_data.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/profile_updated_dialog.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;

  late String _gender;
  late String _countryCode;

  static const _genders = ['Male', 'Female', 'Other'];
  static const _countryCodes = ['+1', '+44', '+91', '+61'];

  @override
  void initState() {
    super.initState();
    final profile = widget.profile;
    _firstNameController = TextEditingController(text: profile.firstName);
    _lastNameController = TextEditingController(text: profile.lastName);
    _addressController = TextEditingController(text: profile.address);
    _cityController = TextEditingController(text: profile.city);
    _stateController = TextEditingController(text: profile.state);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _gender = profile.gender;
    _countryCode = profile.countryCode;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  UserProfile _buildUpdatedProfile() {
    return widget.profile.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      gender: _gender,
      email: _emailController.text.trim(),
      countryCode: _countryCode,
      phone: _phoneController.text.trim(),
    );
  }

  Future<void> _saveProfile() async {
    final updatedProfile = _buildUpdatedProfile();

    await ProfileUpdatedDialog.show(
      context,
      onContinue: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop(updatedProfile);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
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
                    title: 'Edit Profile',
                    whiteBackButton: true,
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                    child: Column(
                      children: [
                        ProfileAvatarSection(
                          displayName: widget.profile.displayName,
                          email: widget.profile.profileEmail,
                          showCamera: true,
                        ),
                        24.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: ProfileFormField(
                                controller: _firstNameController,
                                hintText: 'First Name',
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: ProfileFormField(
                                controller: _lastNameController,
                                hintText: 'Last Name',
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        ProfileFormField(
                          controller: _addressController,
                          hintText: 'Address',
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: ProfileFormField(
                                controller: _cityController,
                                hintText: 'City',
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: ProfileFormField(
                                controller: _stateController,
                                hintText: 'State',
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        ProfileDropdownField(
                          hintText: 'Gender',
                          value: _gender,
                          items: _genders,
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _gender = value);
                            }
                          },
                        ),
                        14.verticalSpace,
                        ProfileFormField(
                          controller: _emailController,
                          hintText: 'Email',
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          suffix: const ProfileVerifiedBadge(),
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            SizedBox(
                              width: 88.w,
                              child: ProfileDropdownField(
                                hintText: '+1',
                                value: _countryCode,
                                items: _countryCodes,
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() => _countryCode = value);
                                  }
                                },
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: ProfileFormField(
                                controller: _phoneController,
                                hintText: 'Phone Number',
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                suffix: const ProfileVerifiedBadge(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                  child: ProfilePrimaryButton(
                    label: 'Next',
                    onPressed: _saveProfile,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
