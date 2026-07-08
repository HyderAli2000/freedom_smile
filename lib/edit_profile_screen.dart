import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/user_profile_data.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/profile_updated_dialog.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';
import 'package:get/get.dart';

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

  static const _genderValues = ['Male', 'Female', 'Other'];
  static const _countryCodes = ['+1', '+44', '+91', '+61'];

  List<String> get _genderItems => [
        'gender_male'.tr,
        'gender_female'.tr,
        'gender_other'.tr,
      ];

  String get _genderDisplayValue {
    final index = _genderValues.indexOf(_gender);
    return index >= 0 ? _genderItems[index] : _gender;
  }

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
                  child: PageHeader(
                    title: 'edit_profile'.tr,
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
                                hintText: 'first_name'.tr,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: ProfileFormField(
                                controller: _lastNameController,
                                hintText: 'last_name'.tr,
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        ProfileFormField(
                          controller: _addressController,
                          hintText: 'address'.tr,
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: ProfileFormField(
                                controller: _cityController,
                                hintText: 'city'.tr,
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: ProfileFormField(
                                controller: _stateController,
                                hintText: 'state'.tr,
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        ProfileDropdownField(
                          hintText: 'gender'.tr,
                          value: _genderDisplayValue,
                          items: _genderItems,
                          onChanged: (value) {
                            if (value != null) {
                              final index = _genderItems.indexOf(value);
                              if (index >= 0) {
                                setState(() => _gender = _genderValues[index]);
                              }
                            }
                          },
                        ),
                        14.verticalSpace,
                        ProfileFormField(
                          controller: _emailController,
                          hintText: 'email'.tr,
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
                                hintText: 'phone_number'.tr,
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
                    label: 'next'.tr,
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
