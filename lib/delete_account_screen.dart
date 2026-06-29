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

  static const _reasons = [
    'Privacy Concerns',
    'Switching to another service',
    'Too many notifications',
    "I'm facing technical issues",
    'Other',
  ];

  final _otherReasonController = TextEditingController();
  final _passwordController = TextEditingController();

  String _selectedReason = 'Other';
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
        _passwordError = 'Incorrect password. Please try again';
      });
      return;
    }

    setState(() => _passwordError = null);

    await AccountSuccessDialog.show(
      context,
      icon: Icons.logout_rounded,
      message: 'Your account has been deleted successfully!',
      buttonLabel: 'Login Account',
      onPressed: () {
        Navigator.of(context).pop();
        Get.offAll(() => const LoginScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'Delete Account',
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AccountSectionHeading(
              title: 'Delete your Account',
              subtitle:
                  'Deleting your account is permanent. All your data, messages, history, and preferences will be erased and cannot be restored.',
            ),
            28.verticalSpace,
            Text(
              'Reason Selection (Optional, for analytics)',
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),
            12.verticalSpace,
            ..._reasons.map(
              (reason) => _ReasonRadioTile(
                label: reason,
                isSelected: _selectedReason == reason,
                onTap: () => setState(() => _selectedReason = reason),
              ),
            ),
            if (_selectedReason == 'Other') ...[
              12.verticalSpace,
              AccountMultilineField(
                controller: _otherReasonController,
                hintText: 'Type your reason here..',
              ),
            ],
            28.verticalSpace,
            const AccountSectionHeading(
              title: 'Security Confirmation',
              subtitle:
                  'For security, please enter your password to delete your account.',
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
              label: 'Password',
              controller: _passwordController,
              hintText: 'Enter your Password',
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
          label: 'Confirm',
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
