import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/select_payment_method_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:get/get.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _address = TextEditingController(
    text: 'Lorem Ave 13th St, New York, NY 10011',
  );
  final _notes = TextEditingController();

  @override
  void dispose() {
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'Checkout',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CheckoutEstimatedTimeRow(),
            20.verticalSpace,
            Row(
              children: [
                const Expanded(child: CheckoutSectionTitle('Retainer')),
                Text(
                  '2 Items',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textBody,
                  ),
                ),
              ],
            ),
            12.verticalSpace,
            const CheckoutRetainerItemCard(),
            20.verticalSpace,
            const CheckoutSectionTitle('Delivery Address'),
            12.verticalSpace,
            CheckoutFormField(controller: _address, borderRadius: 999999999.r),
            20.verticalSpace,
            const CheckoutSectionTitle('Special Notes'),
            12.verticalSpace,
            CheckoutFormField(
              borderRadius: 12.r,
              controller: _notes,
              hintText: 'Write here',
              maxLines: 4,
              minLines: 4,
            ),
            20.verticalSpace,
            const CheckoutSectionTitle('Orders Summary'),
            12.verticalSpace,
            const CheckoutOrdersSummary(),
          ],
        ),
      ),
      bottom: CheckoutPrimaryButton(
        label: 'Checkout',
        onPressed: () => Get.to(() => const SelectPaymentMethodScreen()),
      ),
    );
  }
}
