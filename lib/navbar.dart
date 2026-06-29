import 'package:flutter/material.dart';
import 'package:freedom_smile/add_map_home.dart';
import 'package:freedom_smile/home_screen.dart';
import 'package:freedom_smile/referral_screen.dart';
import 'package:freedom_smile/retainers_home.dart';
import 'package:freedom_smile/settings_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/navbar/app_bottom_nav_bar.dart';
import 'package:freedom_smile/widgets/navbar/app_home_app_bar.dart';
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
    return GetBuilder<BottomNavController>(
      builder: (controller) {
        final isMapTab = controller.currentIndex == BottomNavController.mapIndex;

        return Scaffold(
          backgroundColor: AppColor.whiteColor,
          extendBody: true,
          appBar: AppHomeAppBar(onNotificationTap: () {}),
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
  }
}

class BottomNavController extends GetxController {
  static const mapIndex = 2;

  int currentIndex = 0;

  late final List<Widget> pages;
  late final List<AppBottomNavItem> navItems;

  @override
  void onInit() {
    super.onInit();
    navItems = const [
      AppBottomNavItem(label: 'Home', icon: Icons.home_rounded),
      AppBottomNavItem(
        label: 'Retainers',
        icon: Icons.medical_services_outlined,
      ),
      AppBottomNavItem.centerAction(),
      AppBottomNavItem(label: 'Referrals', icon: Icons.groups_outlined),
      AppBottomNavItem(label: 'Settings', icon: Icons.settings_outlined),
    ];

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
