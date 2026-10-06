import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/home_screen.dart';
import 'package:freedom_smile/retainer_checkin_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RetainersHome extends StatefulWidget {
  const RetainersHome({super.key});

  @override
  State<RetainersHome> createState() => _RetainersHomeState();
}

class _RetainersHomeState extends State<RetainersHome> {
  final _userService = UserService();

  bool _loading = true;
  int _todaySeconds = 0;
  int _targetSeconds = 8 * 3600; // backend DAILY_TARGET default
  String _displayMonths = '00';
  bool _orderNow = true;
  List<_PastOrderItem> _orders = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      // Postman 03: wear stats + retainer orders + retainer
      final results = await Future.wait([
        _userService.wearStats(),
        _userService.listRetainerOrders(),
        _userService.getRetainer(),
      ]);

      final wearData = ApiMap.map(results[0].data);
      final wear = ApiMap.map(wearData['wear'] ?? wearData);
      final ordersData = ApiMap.map(results[1].data);
      final ordersRaw = ApiMap.mapList(ordersData, 'orders');
      final retainerData = ApiMap.map(results[2].data);
      final retainer = ApiMap.map(retainerData['retainer'] ?? retainerData);

      if (mounted) {
        setState(() {
          _todaySeconds = ApiMap.intVal(wear['todaySeconds']);
          _targetSeconds = ApiMap.intVal(wear['targetSeconds'], 8 * 3600);
          _displayMonths = ApiMap.str(
            retainer['displayMonths'] ?? retainer['months'],
            '00',
          );
          // Always allow reorder from this card (API orderNow is expiry-gated).
          _orderNow = true;
          // Always replace — empty API must clear dummy/local orders
          _orders = ordersRaw.map(_PastOrderItem.fromJson).toList();
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onOrderNow() {
    Get.to(() => const RetainerCheckinScreen(isOrderFlow: true));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SafeArea(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RetainerStatusCard(
              displayMonths: _displayMonths,
              orderNow: _orderNow,
              onOrderNow: _onOrderNow,
            ),
            28.verticalSpace,
            _UsageInsightsSection(
              todaySeconds: _todaySeconds,
              targetSeconds: _targetSeconds,
            ),
            28.verticalSpace,
            _PastOrdersSection(orders: _orders),
            28.verticalSpace,
            QuoteSection(quote: 'retainers_quote'.tr),
          ],
        ),
      ),
    );
  }
}

class _UsageInsightsSection extends StatelessWidget {
  const _UsageInsightsSection({
    required this.todaySeconds,
    required this.targetSeconds,
  });

  final int todaySeconds;
  final int targetSeconds;

  @override
  Widget build(BuildContext context) {
    final worn =
        todaySeconds.toDouble().clamp(0.0, double.infinity).toDouble();
    final remaining = (targetSeconds - todaySeconds)
        .toDouble()
        .clamp(0.0, double.infinity)
        .toDouble();
    final wornLabel = ApiMap.formatSeconds(todaySeconds);
    final targetLabel = ApiMap.formatSeconds(targetSeconds);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'usage_insights'.tr,
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
                'timestamp_this_week'.tr,
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
                          dataSource: [
                            _ChartSlice('chart_worn'.tr, worn <= 0 ? 0.01 : worn),
                            _ChartSlice(
                              'chart_remaining'.tr,
                              remaining <= 0 ? 0.01 : remaining,
                            ),
                          ],
                          xValueMapper: (item, _) => item.label,
                          yValueMapper: (item, _) => item.hours,
                          innerRadius: '72%',
                          radius: '100%',
                          strokeWidth: 0,
                          pointColorMapper: (item, _) =>
                              item.label == 'chart_worn'.tr
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
                          wornLabel,
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
                'good_job'.tr,
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
                '$wornLabel Hour Out of $targetLabel Hours',
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
  const _PastOrdersSection({required this.orders});

  final List<_PastOrderItem> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'past_orders_history'.tr,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        if (orders.isEmpty)
          Text(
            'No orders yet',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              color: AppColor.textBody,
            ),
          )
        else
          ...orders.map(
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
    required this.subtitle,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String status;

  bool get isDone =>
      status == 'fulfilled' || status == 'delivered' || status == 'completed';

  factory _PastOrderItem.fromJson(Map<String, dynamic> json) {
    final status = ApiMap.str(json['status'], 'requested').toLowerCase();
    final note = ApiMap.str(json['note']);
    final date = ApiMap.formatDate(json['createdAt'] ?? json['updatedAt']);
    final title = ApiMap.str(
      json['title'] ?? json['name'] ?? json['productName'],
      'Retainer reorder',
    );
    final subtitle = [
      if (note.isNotEmpty) note,
      if (date.isNotEmpty) date,
    ].join(' · ');

    return _PastOrderItem(
      title: title,
      subtitle: subtitle.isEmpty ? status : subtitle,
      status: status,
    );
  }
}

class _PastOrderCard extends StatelessWidget {
  const _PastOrderCard({required this.order});

  final _PastOrderItem order;

  @override
  Widget build(BuildContext context) {
    final statusLabel = order.status.isEmpty
        ? 'requested'
        : order.status[0].toUpperCase() + order.status.substring(1);

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
                  order.subtitle,
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
          8.horizontalSpace,
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                order.isDone
                    ? Icons.check_circle_rounded
                    : Icons.schedule_rounded,
                color: AppColor.primaryBlue,
                size: 16.sp,
              ),
              4.horizontalSpace,
              Text(
                statusLabel,
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
