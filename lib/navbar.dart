import 'package:flutter/material.dart';
import 'package:freedom_smile/add_map_home.dart';
import 'package:freedom_smile/home_screen.dart';
import 'package:freedom_smile/notifications_screen.dart';
import 'package:freedom_smile/referral_screen.dart';
import 'package:freedom_smile/retainers_home.dart';
import 'package:freedom_smile/settings_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/navbar/app_bottom_nav_bar.dart';
import 'package:freedom_smile/widgets/navbar/app_home_app_bar.dart';
import 'package:freedom_smile/controllers/locale_controller.dart';
import 'package:get/get.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  void initState() {
    super.initState();
    Get.put(BottomNavController());
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocaleController>(
      builder: (_) {
        return GetBuilder<BottomNavController>(
          init: Get.find<BottomNavController>(),
          builder: (controller) {
            final isMapTab =
                controller.currentIndex == BottomNavController.mapIndex;

            return Scaffold(
              backgroundColor: AppColor.whiteColor,
              extendBody: true,
              appBar: AppHomeAppBar(
                onNotificationTap: () =>
                    Get.to(() => const NotificationsScreen()),
              ),
              body: Stack(
                fit: StackFit.expand,
                children: [
                  if (!isMapTab)
                    Image.asset(
                      AssetImages.bgOthers,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  controller.pages[controller.currentIndex],
                ],
              ),
              bottomNavigationBar: AppBottomNavBar(
                currentIndex: controller.currentIndex,
                items: controller.navItems,
                onTap: controller.itemSelect,
              ),
            );
          },
        );
      },
    );
  }
}

class BottomNavController extends GetxController {
  static const mapIndex = 2;

  int currentIndex = 0;

  late final List<Widget> pages;

  List<AppBottomNavItem> get navItems => [
    AppBottomNavItem(label: 'nav_home'.tr, icon: AssetIcons.homeD),
    AppBottomNavItem(label: 'nav_retainers'.tr, icon: AssetIcons.retainersD),
    const AppBottomNavItem.centerAction(),
    AppBottomNavItem(label: 'nav_referrals'.tr, icon: AssetIcons.referralsD),
    AppBottomNavItem(label: 'nav_settings'.tr, icon: AssetIcons.settingD),
  ];

  @override
  void onInit() {
    super.onInit();
    pages = [
      const HomeScreen(),
      const RetainersHome(),
      const AddMapHome(),
      const ReferralScreen(),
      const SettingsScreen(),
    ];
  }

  void itemSelect(int index) {
    currentIndex = index;
    update();
  }
}
