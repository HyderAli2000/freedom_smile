import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
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
    final oldPassword = _existingPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;
    if (oldPassword.isEmpty || newPassword.isEmpty) {
      ApiSnackbar.error('Please fill all password fields');
      return;
    }
    if (newPassword != confirm) {
      ApiSnackbar.error('Passwords do not match');
      return;
    }
    try {
      final result = await AuthService().changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirm,
      );
      await AccountSuccessDialog.show(
        context,
        icon: Icons.lock_rounded,
        message: result.message.isNotEmpty
            ? result.message
            : 'password_changed_success'.tr,
        buttonLabel: 'go_back'.tr,
        onPressed: () {
          Navigator.of(context).pop();
          Get.back();
        },
      );
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (e) {
      ApiSnackbar.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'change_password'.tr,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AccountPasswordField(
              label: 'existing_password'.tr,
              controller: _existingPasswordController,
              hintText: 'confirm_password'.tr,
              obscureText: _obscureExisting,
              onToggleVisibility: () {
                setState(() => _obscureExisting = !_obscureExisting);
              },
            ),
            18.verticalSpace,
            AccountPasswordField(
              label: 'new_password'.tr,
              controller: _newPasswordController,
              hintText: 'create_new_password'.tr,
              obscureText: _obscureNew,
              helperText: 'password_min_8_chars'.tr,
              onToggleVisibility: () {
                setState(() => _obscureNew = !_obscureNew);
              },
            ),
            18.verticalSpace,
            AccountPasswordField(
              label: 'confirm_password'.tr,
              controller: _confirmPasswordController,
              hintText: 'create_new_password'.tr,
              obscureText: _obscureConfirm,
              helperText: 'password_min_8_chars'.tr,
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
          label: 'reset_password'.tr,
          onPressed: _resetPassword,
        ),
      ),
    );
  }
}
