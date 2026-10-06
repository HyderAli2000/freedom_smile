import 'package:flutter/material.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class NotificationAccessScreen extends StatefulWidget {
  const NotificationAccessScreen({super.key});

  @override
  State<NotificationAccessScreen> createState() =>
      _NotificationAccessScreenState();
}

class _NotificationAccessScreenState extends State<NotificationAccessScreen> {
  bool _loading = false;

  Future<void> _allowAccess() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      // Finalize onboarding on backend (step 5 marks profile complete).
      await AuthService().createProfile({
        'step': 5,
        'isProfileCompleted': true,
        'isNotificationEnabled': true,
      });
      await AppStorage.setProfileComplete(true);
      Get.offAll(() => const Navbar());
    } on ApiException catch (e) {
      // Still enter app if finalize fails after local onboarding,
      // but keep incomplete so splash can retry sync later only if needed.
      // Prefer marking complete locally so restart doesn't loop create-profile.
      await AppStorage.setProfileComplete(true);
      ApiSnackbar.fromException(e);
      Get.offAll(() => const Navbar());
    } catch (e) {
      await AppStorage.setProfileComplete(true);
      ApiSnackbar.error(e.toString());
      Get.offAll(() => const Navbar());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PermissionAccessScaffold(
      iconPath: AssetIcons.noti,
      title: 'Allow Notification access',
      description: 'Stay updated with the reminder, health\nupdates',
      buttonLabel: _loading ? '...' : 'Allow Access',
      onPressed: _loading ? () {} : _allowAccess,
    );
  }
}
