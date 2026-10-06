import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/fit/fit_radio_option.dart';
import 'package:freedom_smile/widgets/fit/re_evaluation_dialog.dart';
import 'package:get/get.dart';

enum FitConfirmationChoice { fitsWell, feelsTight }

/// Screen 2 — Fit confirmation after retainer check-in.
class FitConfirmationScreen extends StatefulWidget {
  const FitConfirmationScreen({
    super.key,
    this.wearsRegularly = true,
    this.isOrderFlow = false,
  });

  final bool wearsRegularly;
  final bool isOrderFlow;

  @override
  State<FitConfirmationScreen> createState() => _FitConfirmationScreenState();
}

class _FitConfirmationScreenState extends State<FitConfirmationScreen> {
  FitConfirmationChoice? _selectedChoice;
  bool _loading = false;
  String _address = '';

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      final result = await AuthService().getProfile();
      final user = result.user;
      final parts = <String>[
        if ((user?.address ?? '').trim().isNotEmpty) user!.address!.trim(),
        if ((user?.city ?? '').trim().isNotEmpty) user!.city!.trim(),
        if ((user?.state ?? '').trim().isNotEmpty) user!.state!.trim(),
      ];
      final composed = parts.join(', ');
      if (!mounted) return;
      setState(() {
        _address = composed.isNotEmpty
            ? composed
            : 'Lorem Ave 13th St, New York, NY 10011';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _address = 'Lorem Ave 13th St, New York, NY 10011';
      });
    }
  }

  Future<void> _editAddress() async {
    final controller = TextEditingController(text: _address);
    final updated = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
        child: Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xffFFFFFF),
                Color.fromARGB(255, 221, 243, 255),
                Color.fromARGB(255, 190, 232, 255),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Delivery Address',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.blackColor,
                ),
              ),
              16.verticalSpace,
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColor.whiteColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    borderSide: BorderSide(
                      color: AppColor.borderLightBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
              20.verticalSpace,
              SizedBox(
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.of(ctx).pop(controller.text.trim()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    controller.dispose();
    if (updated != null && updated.isNotEmpty && mounted) {
      setState(() => _address = updated);
    }
  }

  Future<void> _onSelect(FitConfirmationChoice choice) async {
    setState(() => _selectedChoice = choice);
    if (choice == FitConfirmationChoice.fitsWell) {
      await _handleFitsWell();
    } else {
      await _handleFeelsTight();
    }
  }

  Future<void> _handleFitsWell() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      // Postman: POST /user/fit-check
      final fitResult = await UserService().saveFitCheck(
        fitsComfortably: true,
        wearsRegularly: widget.wearsRegularly,
      );
      if (!mounted) return;

      if (widget.isOrderFlow) {
        // Postman: POST /user/retainer/reorder
        final reorder = await UserService().requestRetainerReorder();
        ApiSnackbar.success(reorder.message);
        if (!mounted) return;
        Get.to(() => CheckoutScreen(deliveryAddress: _address));
      } else {
        ApiSnackbar.success(fitResult.message);
        Get.to(() => CheckoutScreen(deliveryAddress: _address));
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (e) {
      ApiSnackbar.error(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleFeelsTight() async {
    if (_loading) return;
    setState(() => _loading = true);
    try {
      // Postman: POST /user/fit-check
      await UserService().saveFitCheck(
        fitsComfortably: false,
        wearsRegularly: widget.wearsRegularly,
      );
      if (!mounted) return;
      // Dialog Continue → Select Near-by Orthodontist
      await ReEvaluationDialog.show(context);
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (e) {
      ApiSnackbar.error(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onContinue() async {
    if (_selectedChoice == null || _loading) return;
    if (_selectedChoice == FitConfirmationChoice.feelsTight) {
      await _handleFeelsTight();
    } else {
      await _handleFitsWell();
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
                        onTap: () => _onSelect(FitConfirmationChoice.fitsWell),
                      ),
                      FitRadioOption(
                        label: "No, Feels Tight Or Doesn't Fit",
                        isSelected:
                            _selectedChoice == FitConfirmationChoice.feelsTight,
                        onTap: () => _onSelect(FitConfirmationChoice.feelsTight),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: Alignment.topCenter,
                        child: _selectedChoice == FitConfirmationChoice.fitsWell
                            ? Padding(
                                padding: EdgeInsets.only(top: 28.h),
                                child: _DeliveryConfirmationSection(
                                  address: _address,
                                  onEdit: _editAddress,
                                ),
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
                    onPressed: (_selectedChoice == null || _loading)
                        ? null
                        : _onContinue,
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
                      _loading ? '...' : 'Continue',
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
  const _DeliveryConfirmationSection({
    required this.address,
    required this.onEdit,
  });

  final String address;
  final VoidCallback onEdit;

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
                    TextSpan(
                      text: address.isEmpty ? '—' : address,
                    ),
                  ],
                ),
              ),
            ),
            8.horizontalSpace,
            GestureDetector(
              onTap: onEdit,
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
