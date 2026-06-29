import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/widgets/checkout/checkout_widgets.dart';
import 'package:get/get.dart';

class AddNewCardScreen extends StatefulWidget {
  const AddNewCardScreen({super.key});

  @override
  State<AddNewCardScreen> createState() => _AddNewCardScreenState();
}

class _AddNewCardScreenState extends State<AddNewCardScreen> {
  final _cardNumber = TextEditingController();
  final _holderName = TextEditingController();
  final _expDate = TextEditingController();
  final _cvv = TextEditingController();

  @override
  void dispose() {
    _cardNumber.dispose();
    _holderName.dispose();
    _expDate.dispose();
    _cvv.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CheckoutScaffold(
      title: 'Add New Card',
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(top: 28.h, bottom: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckoutFormField(
              controller: _cardNumber,
              hintText: 'Card Number',
              keyboardType: TextInputType.number,
            ),
            14.verticalSpace,
            CheckoutFormField(
              controller: _holderName,
              hintText: 'Card Holder Name',
            ),
            14.verticalSpace,
            Row(
              children: [
                Expanded(
                  child: CheckoutFormField(
                    controller: _expDate,
                    hintText: 'Exp Date',
                    suffix: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.calendar_month_outlined,
                        color: AppColor.primaryBlue,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
                12.horizontalSpace,
                Expanded(
                  child: CheckoutFormField(
                    controller: _cvv,
                    hintText: 'CVV',
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: CheckoutPrimaryButton(
        label: 'Add Now',
        onPressed: Get.back,
      ),
    );
  }
}
