import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';

class CheckoutScaffold extends StatelessWidget {
  const CheckoutScaffold({
    super.key,
    required this.title,
    required this.body,
    this.bottom,
  });

  final String title;
  final Widget body;
  final Widget? bottom;

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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(title: title),
                Expanded(child: body),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutSectionTitle extends StatelessWidget {
  const CheckoutSectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColor.textDark,
      ),
    );
  }
}

class CheckoutPrimaryButton extends StatelessWidget {
  const CheckoutPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 28.h),
      child: SizedBox(
        width: double.infinity,
        height: 52.h,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryBlue,
            foregroundColor: AppColor.whiteColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.r),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutFormField extends StatelessWidget {
  const CheckoutFormField({
    super.key,
    required this.controller,
    this.hintText,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
    this.readOnly = false,
    this.borderRadius = 999999999,
  });

  final TextEditingController controller;
  final String? hintText;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  final bool readOnly;
  final double borderRadius;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.textDark,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: AppFonts.family,
          fontFamilyFallback: AppFonts.fallback,
          fontSize: 14.sp,
          color: AppColor.textBody,
        ),
        filled: true,
        fillColor: AppColor.profileOptionBg.withValues(alpha: 0.85),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: AppColor.primaryBlue),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: BorderSide(color: AppColor.primaryBlue),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius.r),
          borderSide: const BorderSide(color: AppColor.primaryBlue),
        ),
        suffixIcon: suffix,
      ),
    );
  }
}

class CheckoutEstimatedTimeRow extends StatelessWidget {
  const CheckoutEstimatedTimeRow({super.key, this.label = '02 Days'});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.access_time_rounded,
          color: AppColor.primaryBlue,
          size: 22.sp,
        ),
        8.horizontalSpace,
        Text(
          'Estimated Time',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textDark,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textDark,
          ),
        ),
      ],
    );
  }
}

class CheckoutRetainerItemCard extends StatelessWidget {
  const CheckoutRetainerItemCard({
    super.key,
    this.title = 'Lorem Ipsum',
    this.price = '\$19.99',
  });

  final String title;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: AppColor.primaryBlue,
              borderRadius: BorderRadius.circular(12.r),
            ),
            padding: EdgeInsets.all(10.w),
            child: Image.asset(AssetImages.teet, fit: BoxFit.contain),
          ),
          12.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
              Text(
                price,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CheckoutOrdersSummary extends StatelessWidget {
  const CheckoutOrdersSummary({
    super.key,
    this.subTotal = 19.99,
    this.deliveryCharges = 5.2,
    this.tax = 0.5,
  });

  final double subTotal;
  final double deliveryCharges;
  final double tax;

  double get total => subTotal + deliveryCharges + tax;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _SummaryRow(label: 'Sub Total', value: subTotal),

        Divider(color: AppColor.borderLightBlue.withValues(alpha: 0.6)),
        10.verticalSpace,
        _SummaryRow(label: 'Delivery Charges', value: deliveryCharges),

        Divider(color: AppColor.borderLightBlue.withValues(alpha: 0.6)),
        10.verticalSpace,
        _SummaryRow(label: 'Tax', value: tax),

        Divider(color: AppColor.borderLightBlue.withValues(alpha: 0.6)),
        10.verticalSpace,
        _SummaryRow(label: 'Total', value: total, isTotal: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  final String label;
  final double value;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
            color: AppColor.textBody,
          ),
        ),
        const Spacer(),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: isTotal ? 16.sp : 14.sp,
            fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
            color: AppColor.textBody,
          ),
        ),
      ],
    );
  }
}
