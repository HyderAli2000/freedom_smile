import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:freedom_smile/widgets/settings/account_form_widgets.dart';
import 'package:freedom_smile/widgets/settings/account_success_dialog.dart';
import 'package:get/get.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  static const _email = 'emailly2023@gmail.com';
  static const _correctPassword = '123';

  static const _reasonKeys = [
    'delete_reason_privacy',
    'delete_reason_switching',
    'delete_reason_notifications',
    'delete_reason_technical',
    'other',
  ];

  final _otherReasonController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedReason = 'other';
  bool _obscurePassword = true;
  String? _passwordError;

  @override
  void dispose() {
    _otherReasonController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final password = _passwordController.text.trim();
    if (password != _correctPassword) {
      setState(() {
        _passwordError = 'incorrect_password'.tr;
      });
      return;
    }

    setState(() => _passwordError = null);

    await AccountSuccessDialog.show(
      context,
      icon: Icons.logout_rounded,
      message: 'account_deleted_success'.tr,
      buttonLabel: 'login_account'.tr,
      onPressed: () {
        Navigator.of(context).pop();
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'delete_account'.tr,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountSectionHeading(
              title: 'delete_your_account'.tr,
              subtitle: 'delete_account_warning'.tr,
            ),
            28.verticalSpace,
            Text(
              'reason_selection_optional'.tr,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),
            12.verticalSpace,
            ..._reasonKeys.map(
              (reasonKey) => _ReasonRadioTile(
                label: reasonKey.tr,
                isSelected: _selectedReason == reasonKey,
                onTap: () => setState(() => _selectedReason = reasonKey),
              ),
            ),
            if (_selectedReason == 'other') ...[
              12.verticalSpace,
              AccountMultilineField(
                controller: _otherReasonController,
                hintText: 'type_your_reason'.tr,
              ),
            ],
            28.verticalSpace,
            AccountSectionHeading(
              title: 'security_confirmation'.tr,
              subtitle: 'enter_password_to_delete'.tr,
            ),
            16.verticalSpace,
            Text(
              _email,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),
            16.verticalSpace,
            AccountPasswordField(
              label: 'password'.tr,
              controller: _passwordController,
              hintText: 'enter_your_password'.tr,
              obscureText: _obscurePassword,
              errorText: _passwordError,
              onToggleVisibility: () {
                setState(() => _obscurePassword = !_obscurePassword);
              },
            ),
          ],
        ),
      ),
      bottom: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
        child: AccountPrimaryButton(
          label: 'confirm'.tr,
          onPressed: _confirmDelete,
        ),
      ),
    );
  }
}

class _ReasonRadioTile extends StatelessWidget {
  const _ReasonRadioTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12.r),
          child: Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected
                        ? AppColor.primaryBlue
                        : AppColor.borderLightBlue,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textDark,
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
