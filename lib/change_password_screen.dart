import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/delete_account_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:freedom_smile/widgets/settings/account_form_widgets.dart';
import 'package:freedom_smile/widgets/settings/account_success_dialog.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _existingPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscureExisting = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _existingPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    await AccountSuccessDialog.show(
      context,
      icon: Icons.lock_rounded,
      message:
          'Your password has been changed successfully. You can now login with your new password.',
      buttonLabel: 'Go Back',
      onPressed: () {
        Navigator.of(context).pop();
        Get.back();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'Change Password',
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountPasswordField(
              label: 'Existing Password',
              controller: _existingPasswordController,
              hintText: 'Confirm Password',
              obscureText: _obscureExisting,
              onToggleVisibility: () {
                setState(() => _obscureExisting = !_obscureExisting);
              },
            ),
            18.verticalSpace,
            AccountPasswordField(
              label: 'New Password',
              controller: _newPasswordController,
              hintText: 'Create New Password',
              obscureText: _obscureNew,
              helperText: 'Must be at least 8 characters',
              onToggleVisibility: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            18.verticalSpace,
            AccountPasswordField(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              hintText: 'Create New Password',
              obscureText: _obscureConfirm,
              helperText: 'Must be at least 8 characters',
              onToggleVisibility: () {
                setState(() => _obscureConfirm = !_obscureConfirm);
              },
            ),
            20.verticalSpace,
            const PasswordRequirementsBox(),
          ],
        ),
      ),
      bottom: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 16.h),
        child: AccountPrimaryButton(
          label: 'Reset Password',
          onPressed: _resetPassword,
        ),
      ),
    );
  }
}
