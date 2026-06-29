import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:get/get.dart';

class OrderConfirmedScreen extends StatelessWidget {
  const OrderConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),

          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100.w,
                            height: 100.w,
                            decoration: const BoxDecoration(
                              color: AppColor.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(22.w),
                            child: Image.asset(
                              AssetIcons.teeth1,
                              fit: BoxFit.contain,
                            ),
                          ),
                          28.verticalSpace,
                          Text(
                            'Your Order Confirmed',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textDark,
                            ),
                          ),
                          16.verticalSpace,
                          Text(
                            'Thank you for your order. Your Retainer will arrive in approximately 02 Days.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.textBody,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                CheckoutPrimaryButton(
                  label: 'Continue',
                  onPressed: () => Get.offAll(() => const Navbar()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
