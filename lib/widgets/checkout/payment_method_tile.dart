import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';

enum PaymentMethodKind { stripe, paypal, applePay, mastercard, reward }

class PaymentMethodOption {
  PaymentMethodOption({
    required this.id,
    required this.kind,
    required this.title,
    this.slidable = false,
  });

  final String id;
  final PaymentMethodKind kind;
  final String title;
  final bool slidable;
}

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final PaymentMethodOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColor.borderLightBlue.withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              _PaymentLeading(kind: option.kind),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  option.title,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textDark,
                  ),
                ),
              ),
              _PaymentRadio(selected: selected),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentRadio extends StatelessWidget {
  const _PaymentRadio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColor.primaryBlue, width: 2),
        color: selected ? AppColor.primaryBlue : Colors.transparent,
      ),
      child: selected
          ? Center(
              child: Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor,
                ),
              ),
            )
          : null,
    );
  }
}

class _PaymentLeading extends StatelessWidget {
  const _PaymentLeading({required this.kind});

  final PaymentMethodKind kind;

  @override
  Widget build(BuildContext context) {
    return switch (kind) {
      PaymentMethodKind.stripe => _leadingBox(
          color: const Color(0xff635BFF),
          child: Text(
            'stripe',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
        ),
      PaymentMethodKind.paypal => _leadingBox(
          color: const Color(0xff1A1F71),
          child: Text(
            'PayPal',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xff009CDE),
            ),
          ),
        ),
      PaymentMethodKind.applePay => _leadingBox(
          color: AppColor.blackColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.apple, color: AppColor.whiteColor, size: 16.sp),
              Text(
                ' Pay',
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.whiteColor,
                ),
              ),
            ],
          ),
        ),
      PaymentMethodKind.mastercard => _leadingBox(
          color: AppColor.blackColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _mcCircle(const Color(0xffEB001B)),
              Transform.translate(
                offset: Offset(-6.w, 0),
                child: _mcCircle(const Color(0xffF79E1B)),
              ),
            ],
          ),
        ),
      PaymentMethodKind.reward => _leadingBox(
          color: AppColor.primaryBlue,
          child: Icon(
            Icons.card_giftcard_rounded,
            color: AppColor.whiteColor,
            size: 22.sp,
          ),
        ),
    };
  }

  Widget _mcCircle(Color color) {
    return Container(
      width: 18.r,
      height: 18.r,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _leadingBox({required Color color, required Widget child}) {
    return Container(
      width: 44.w,
      height: 32.h,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: child,
    );
  }
}
