import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/add_new_card_screen.dart';
import 'package:freedom_smile/order_confirmed_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:freedom_smile/widgets/checkout/payment_method_tile.dart';
import 'package:get/get.dart';

class SelectPaymentMethodScreen extends StatefulWidget {
  const SelectPaymentMethodScreen({super.key});

  @override
  State<SelectPaymentMethodScreen> createState() =>
      _SelectPaymentMethodScreenState();
}

class _SelectPaymentMethodScreenState extends State<SelectPaymentMethodScreen> {
  late List<PaymentMethodOption> _methods;
  String _selectedId = 'stripe';

  @override
  void initState() {
    super.initState();
    _methods = _defaultMethods();
  }

  List<PaymentMethodOption> _defaultMethods() {
    return [
      PaymentMethodOption(
        id: 'stripe',
        kind: PaymentMethodKind.stripe,
        title: 'Stripe',
      ),
      PaymentMethodOption(
        id: 'paypal',
        kind: PaymentMethodKind.paypal,
        title: 'Paypal',
        slidable: true,
      ),
      PaymentMethodOption(
        id: 'apple',
        kind: PaymentMethodKind.applePay,
        title: '**** **** **** 4563',
        slidable: true,
      ),
      PaymentMethodOption(
        id: 'mastercard',
        kind: PaymentMethodKind.mastercard,
        title: '**** **** **** 4563',
        slidable: true,
      ),
      PaymentMethodOption(
        id: 'reward',
        kind: PaymentMethodKind.reward,
        title: 'From Reward',
      ),
    ];
  }

  void _select(String id) => setState(() => _selectedId = id);

  void _remove(String id) {
    setState(() {
      _methods.removeWhere((m) => m.id == id);
      if (_selectedId == id && _methods.isNotEmpty) {
        _selectedId = _methods.first.id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'Select Payment Method',
      body: ListView.builder(
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        physics: const BouncingScrollPhysics(),
        itemCount: _methods.length + 1,
        itemBuilder: (context, index) {
          if (index == _methods.length) {
            return Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 8.h),
                child: _AddNewCardRow(
                  onTap: () => Get.to(() => const AddNewCardScreen()),
                ),
              ),
            );
          }

          final option = _methods[index];
          final selected = _selectedId == option.id;

          return Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: option.slidable
                ? _SlidablePaymentMethodTile(
                    key: ValueKey(option.id),
                    option: option,
                    selected: selected,
                    onTap: () => _select(option.id),
                    onDelete: () => _remove(option.id),
                  )
                : PaymentMethodTile(
                    option: option,
                    selected: selected,
                    onTap: () => _select(option.id),
                  ),
          );
        },
      ),
      bottom: CheckoutPrimaryButton(
        label: 'Pay Now',
        onPressed: () => Get.to(() => const OrderConfirmedScreen()),
      ),
    );
  }
}

class _SlidablePaymentMethodTile extends StatelessWidget {
  const _SlidablePaymentMethodTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
    required this.onDelete,
  });

  final PaymentMethodOption option;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14.r),
      child: Dismissible(
        key: ValueKey(option.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => onDelete(),
        background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 22.w),
          color: AppColor.googleRed,
          child: Icon(
            Icons.delete_outline_rounded,
            color: AppColor.whiteColor,
            size: 26.sp,
          ),
        ),
        child: PaymentMethodTile(
          option: option,
          selected: selected,
          onTap: onTap,
        ),
      ),
    );
  }
}

class _AddNewCardRow extends StatelessWidget {
  const _AddNewCardRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9999),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 4.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28.r,
                height: 28.r,
                decoration: const BoxDecoration(
                  color: AppColor.blackColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: AppColor.whiteColor, size: 18.sp),
              ),
              8.horizontalSpace,
              Text(
                'Add New Card',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
