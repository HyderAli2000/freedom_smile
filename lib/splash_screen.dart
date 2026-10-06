import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/create_profile.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/splash_other.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    if (!AppStorage.isLoggedIn) {
      Get.off(() => const SplashOther());
      return;
    }

    try {
      final result = await AuthService().getProfile();
      final completed = result.user?.isProfileCompleted == true;
      await AppStorage.setProfileComplete(completed);

      if (!mounted) return;
      if (completed) {
        Get.off(() => const Navbar());
      } else {
        Get.off(
          () => CreateProfileScreen(
            prefillEmail: result.user?.email ?? AppStorage.email ?? '',
            isEdit: false,
          ),
        );
      }
    } on ApiException catch (e) {
      // Expired / invalid session → login flow
      if (e.statusCode == 410 || e.statusCode == 440 || e.statusCode == 401) {
        await AppStorage.clearSession();
        if (mounted) Get.off(() => const LoginScreen());
        return;
      }
      // Offline fallback: trust last known local flag
      if (!mounted) return;
      if (AppStorage.isProfileComplete) {
        Get.off(() => const Navbar());
      } else {
        Get.off(
          () => CreateProfileScreen(
            prefillEmail: AppStorage.email ?? '',
            isEdit: false,
          ),
        );
      }
    } catch (_) {
      if (!mounted) return;
      if (AppStorage.isProfileComplete) {
        Get.off(() => const Navbar());
      } else {
        Get.off(
          () => CreateProfileScreen(
            prefillEmail: AppStorage.email ?? '',
            isEdit: false,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AssetImages.background, fit: BoxFit.cover),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              AssetImages.splashBG,
              fit: BoxFit.fill,
              width: double.infinity,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0.35.sh,
            child: Image.asset(
              AssetImages.dumble,
              fit: BoxFit.contain,
              width: 320.w,
              height: 0.15.sh,
              alignment: Alignment.center,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              AssetImages.btm,
              fit: BoxFit.fitWidth,
              alignment: Alignment.bottomCenter,
            ),
          ),
          Positioned(
            top: 0.22.sh,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                AssetImages.logo,
                width: 320.w,
                height: 0.15.sh,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
