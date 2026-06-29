import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Get.off(() => const SplashOther());
      }
    });
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
