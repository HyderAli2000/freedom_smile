import 'package:flutter/material.dart';
import 'package:freedom_smile/notification_access_screen.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/auth/light_auth_layout.dart';
import 'package:get/get.dart';

class LocationAccessScreen extends StatelessWidget {
  const LocationAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PermissionAccessScaffold(
      iconPath: AssetIcons.location,
      title: 'Allow Location Access',
      description:
          'To provide the best experience for your\nnearby Orthodontist',
      buttonLabel: 'Allow Access',
      onPressed: () => Get.to(() => const NotificationAccessScreen()),
    );
  }
}
