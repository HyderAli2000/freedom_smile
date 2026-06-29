import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/retainer_type_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/auth/auth_widgets.dart';
import 'package:get/get.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({
    super.key,
    this.prefillEmail,
    this.isEdit = false,
  });

  final String? prefillEmail;
  final bool isEdit;

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  late final TextEditingController _emailController;
  final _phoneController = TextEditingController(text: '+123 456 7890');

  String? _gender;
  String _countryCode = '+1';

  static const _genders = ['Male', 'Female', 'Other'];
  static const _countryCodes = ['+1', '+44', '+91', '+61'];

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(
      text: widget.prefillEmail ?? 'william.roy@domain.com',
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              const _CreateProfileHeader(),
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
                    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
                    child: Column(
                      children: [
                        const _ProfileAvatarPicker(),
                        28.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: _ProfileInputField(
                                controller: _firstNameController,
                                hintText: 'First Name',
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: _ProfileInputField(
                                controller: _lastNameController,
                                hintText: 'Last Name',
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        _ProfileInputField(
                          controller: _addressController,
                          hintText: 'Address',
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            Expanded(
                              child: _ProfileInputField(
                                controller: _cityController,
                                hintText: 'City',
                              ),
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: _ProfileInputField(
                                controller: _stateController,
                                hintText: 'State',
                              ),
                            ),
                          ],
                        ),
                        14.verticalSpace,
                        _ProfileDropdownField(
                          hintText: 'Gender',
                          value: _gender,
                          items: _genders,
                          onChanged: (value) {
                            setState(() => _gender = value);
                          },
                        ),
                        14.verticalSpace,
                        _ProfileInputField(
                          controller: _emailController,
                          hintText: 'Email',
                          readOnly: true,
                          suffix: const _VerifiedBadge(),
                        ),
                        14.verticalSpace,
                        Row(
                          children: [
                            SizedBox(
                              width: 88.w,
                              child: _ProfileDropdownField(
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
                              child: _ProfileInputField(
                                controller: _phoneController,
                                hintText: 'Phone Number',
                                readOnly: true,
                                keyboardType: TextInputType.phone,
                                suffix: const _VerifiedBadge(),
                              ),
                            ),
                          ],
                        ),
                        32.verticalSpace,
                        AuthPrimaryButton(
                          label: 'Continue',
                          onPressed: () {
                            Get.to(() => const RetainerTypeScreen());
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateProfileHeader extends StatelessWidget {
  const _CreateProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Create Profile',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: Get.back,
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
              const Spacer(),
              Text(
                'Step 1/5',
                style: TextStyle(
                  fontSize: 14.sp,
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

class _ProfileAvatarPicker extends StatelessWidget {
  const _ProfileAvatarPicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150.w,
      height: 150.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.whiteColor,
        border: Border.all(
          color: AppColor.primaryBlue.withValues(alpha: 0.6),
          width: 5.w,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: AppColor.whiteColor.withValues(alpha: 0.35),
        //     blurRadius: 18,
        //     spreadRadius: 4,
        //   ),
        // ],
      ),
      child: Image.asset(AssetIcons.cam, color: AppColor.buttonTextClr),
    );
  }
}

class _ProfileInputField extends StatelessWidget {
  const _ProfileInputField({
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
        readOnly: readOnly,
        keyboardType: keyboardType,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColor.whiteColor,
        ),
        cursorColor: AppColor.whiteColor,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.whiteColor.withValues(alpha: 0.65),
          ),
          isDense: true,
          suffix: suffix == null
              ? null
              : Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: suffix,
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 18.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}

class _ProfileDropdownField extends StatelessWidget {
  const _ProfileDropdownField({
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
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(999999.r),
        border: Border.all(
          color: AppColor.whiteColor.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hintText,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.whiteColor.withValues(alpha: 0.65),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.whiteColor.withValues(alpha: 0.85),
            size: 22.sp,
          ),
          dropdownColor: AppColor.primaryBlue,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.whiteColor,
          ),
          items: items
              .map(
                (item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item)),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18.w,
          height: 18.w,
          decoration: const BoxDecoration(
            color: AppColor.whiteColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 12.sp,
            color: AppColor.primaryBlue,
          ),
        ),
        6.horizontalSpace,
        Text(
          'Verified',
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.whiteColor,
          ),
        ),
      ],
    );
  }
}
