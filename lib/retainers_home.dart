import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/home_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RetainersHome extends StatelessWidget {
  const RetainersHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const RetainerStatusCard(),
            28.verticalSpace,
            const _UsageInsightsSection(),
            28.verticalSpace,
            const _PastOrdersSection(),
            28.verticalSpace,
            const QuoteSection(
              quote: 'Clean your retainer daily to avoid bacteria',
            ),
          ],
        ),
      ),
    );
  }
}

class _UsageInsightsSection extends StatelessWidget {
  const _UsageInsightsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Usage Insights',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        Container(
          padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                'Your Timestamp of this Week',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.textBody,
                ),
              ),
              12.verticalSpace,
              SizedBox(
                height: 220.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SfCircularChart(
                      margin: EdgeInsets.zero,
                      series: <CircularSeries<_ChartSlice, String>>[
                        DoughnutSeries<_ChartSlice, String>(
                          dataSource: const [
                            _ChartSlice('Worn', 19.02),
                            _ChartSlice('Remaining', 1.98),
                          ],
                          xValueMapper: (item, _) => item.label,
                          yValueMapper: (item, _) => item.hours,
                          innerRadius: '72%',
                          radius: '100%',
                          strokeWidth: 0,
                          pointColorMapper: (item, _) => item.label == 'Worn'
                              ? AppColor.calendarBg
                              : AppColor.calendarSelectedDay,
                        ),
                      ],
                    ),
                    Positioned(
                      top: 72.h,
                      right: 48.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.calendarBg,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          '19:00:51',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              8.verticalSpace,
              Text(
                'Good Job',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.textDark,
                ),
              ),
              8.verticalSpace,
              Text(
                '19:00:51 Hour Out of 21:00:00 Hours',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChartSlice {
  const _ChartSlice(this.label, this.hours);

  final String label;
  final double hours;
}

class _PastOrdersSection extends StatelessWidget {
  const _PastOrdersSection();

  static const _orders = [
    _PastOrderItem(
      title: 'Lorem Ipsum',
      description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit.',
      price: '\$19.99',
      status: 'Delivered',
    ),
    _PastOrderItem(
      title: 'Lorem Ipsum',
      description: 'Lorem Ipsum Dolor Sit Amet, Consectetur Adipiscing Elit.',
      price: '\$19.99',
      status: 'Delivered',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Past Orders / History',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        ..._orders.map(
          (order) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _PastOrderCard(order: order),
          ),
        ),
      ],
    );
  }
}

class _PastOrderItem {
  const _PastOrderItem({
    required this.title,
    required this.description,
    required this.price,
    required this.status,
  });

  final String title;
  final String description;
  final String price;
  final String status;
}

class _PastOrderCard extends StatelessWidget {
  const _PastOrderCard({required this.order});

  final _PastOrderItem order;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textDark,
                  ),
                ),
                6.verticalSpace,
                Text(
                  order.price,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textDark,
                  ),
                ),
              ],
            ),
          ),
          8.horizontalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: AppColor.primaryBlue,
                size: 16.sp,
              ),
              4.horizontalSpace,
              Text(
                order.status,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
