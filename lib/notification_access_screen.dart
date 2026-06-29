import 'package:flutter/material.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class NotificationAccessScreen extends StatelessWidget {
  const NotificationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionAccessScaffold(
      iconPath: AssetIcons.noti,
      title: 'Allow Notification access',
      description: 'Stay updated with the reminder, health\nupdates',
      buttonLabel: 'Allow Access',
      onPressed: () => Get.offAll(() => const Navbar()),
    );
  }
}
