import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/fit/fit_radio_option.dart';
import 'package:freedom_smile/widgets/fit/re_evaluation_dialog.dart';
import 'package:get/get.dart';

enum FitConfirmationChoice { fitsWell, feelsTight }

class FitConfirmationScreen extends StatefulWidget {
  const FitConfirmationScreen({super.key});

  @override
  State<FitConfirmationScreen> createState() => _FitConfirmationScreenState();
}

class _FitConfirmationScreenState extends State<FitConfirmationScreen> {
  FitConfirmationChoice? _selectedChoice;

  void _onContinue() {
    if (_selectedChoice == FitConfirmationChoice.feelsTight) {
      ReEvaluationDialog.show(context);
      return;
    }

    if (_selectedChoice == FitConfirmationChoice.fitsWell) {
      Get.to(() => const CheckoutScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const PageHeader(title: 'Fit Confirmation'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Does your retainer still\nfit comfortably?',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textDark,
                          height: 1.35,
                        ),
                      ),
                      28.verticalSpace,
                      FitRadioOption(
                        label: 'Yes, Fits Well',
                        isSelected:
                            _selectedChoice == FitConfirmationChoice.fitsWell,
                        onTap: () {
                          setState(
                            () => _selectedChoice =
                                FitConfirmationChoice.fitsWell,
                          );
                        },
                      ),
                      FitRadioOption(
                        label: "No, Feels Tight Or Doesn't Fit",
                        isSelected:
                            _selectedChoice == FitConfirmationChoice.feelsTight,
                        onTap: () {
                          setState(
                            () => _selectedChoice =
                                FitConfirmationChoice.feelsTight,
                          );
                        },
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: _selectedChoice == FitConfirmationChoice.fitsWell
                            ? Padding(
                                padding: EdgeInsets.only(top: 28.h),
                                child: const _DeliveryConfirmationSection(),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                child: SizedBox(
                  width: double.infinity,
                  height: 52.h,
                  child: ElevatedButton(
                    onPressed: _selectedChoice == null ? null : _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryBlue,
                      foregroundColor: AppColor.whiteColor,
                      disabledBackgroundColor: AppColor.primaryBlue.withValues(
                        alpha: 0.45,
                      ),
                      disabledForegroundColor: AppColor.whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeliveryConfirmationSection extends StatelessWidget {
  const _DeliveryConfirmationSection();

  static const _address = 'Lorem Ave 13th St, New York, NY 10011';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Delivery Confirmation',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.sp,
                    height: 1.45,
                    color: AppColor.textBody,
                  ),
                  children: [
                    TextSpan(
                      text: 'Delivery Address:\n',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.textDark,
                      ),
                    ),
                    const TextSpan(text: _address),
                  ],
                ),
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.edit_outlined,
                color: AppColor.primaryBlue,
                size: 20.sp,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: SizedBox(
            height: 180.h,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(AssetImages.map, fit: BoxFit.cover),
                Align(
                  alignment: const Alignment(0.1, -0.15),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: AppColor.primaryBlue,
                    size: 36.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
