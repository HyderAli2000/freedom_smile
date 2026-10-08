import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/educational_tip_detail_screen.dart';
import 'package:freedom_smile/educational_tips_screen.dart';
import 'package:freedom_smile/retainer_checkin_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/educational/educational_tip_card.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _userService = UserService();

  bool _loading = true;
  bool _marking = false;

  String _displayMonths = '05';
  bool _orderNow = true;
  double _progress = 0.62;
  int _todaySeconds = 5 * 3600 + 21 * 60;
  bool _isWearing = false;
  List<EducationalTip> _tips = EducationalTipsData.tips;

  @override
  void initState() {
    super.initState();
    _loadHome();
  }

  Future<void> _loadHome() async {
    try {
      final result = await _userService.home();
      final data = ApiMap.map(result.data);

      final retainer = ApiMap.map(data['retainer']);
      final wear = ApiMap.map(data['wear']);
      final tipsRaw = ApiMap.mapList(data, 'tips');

      if (mounted) {
        setState(() {
          final months = ApiMap.str(
            retainer['displayMonths'] ?? retainer['months'],
            _displayMonths,
          );
          _displayMonths = months;
          // Always allow reorder from this card (API orderNow is expiry-gated).
          _orderNow = true;
          _progress =
              (ApiMap.doubleVal(wear['progressPercent'], _progress * 100) / 100)
                  .clamp(0.0, 1.0);
          _todaySeconds = ApiMap.intVal(wear['todaySeconds'], _todaySeconds);
          _isWearing = ApiMap.boolVal(wear['isWearing'], _isWearing);
          if (tipsRaw.isNotEmpty) {
            _tips = tipsRaw.map(EducationalTip.fromJson).toList();
          }
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      // Keep local fallbacks.
      if (mounted) setState(() => _loading = false);
    }
  }

  void _onOrderNow() {
    // Only from Order Now: wearing check-in → fit confirmation → checkout / map
    Get.to(() => const RetainerCheckinScreen(isOrderFlow: true));
  }

  Future<void> _onMarkWorn() async {
    if (_marking) return;
    setState(() => _marking = true);
    try {
      final action = _isWearing ? 'complete' : 'start';
      final result = await _userService.markWorn(action: action);
      ApiSnackbar.success(result.message);
      await _loadHome();
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Ignore unexpected errors; snackbar already covers API failures.
    } finally {
      if (mounted) setState(() => _marking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RetainerStatusCard(
              displayMonths: _displayMonths,
              orderNow: _orderNow,
              onOrderNow: _onOrderNow,
            ),
            28.verticalSpace,
            _WornProgressCircle(
              progress: _progress,
              todaySeconds: _todaySeconds,
              marking: _marking,
              onMarkWorn: _onMarkWorn,
            ),
            28.verticalSpace,
            const QuoteSection(),
            28.verticalSpace,
            _EducationalTipsSection(tips: _tips),
          ],
        ),
      ),
    );
  }
}

class RetainerStatusCard extends StatelessWidget {
  const RetainerStatusCard({
    super.key,
    this.displayMonths,
    this.orderNow = true,
    this.onOrderNow,
  });

  final String? displayMonths;

  /// Kept for callers; Order Now is always shown so users can reorder.
  final bool orderNow;
  final VoidCallback? onOrderNow;

  @override
  Widget build(BuildContext context) {
    final monthsLabel = displayMonths == null || displayMonths!.isEmpty
        ? 'retainer_months_sample'.tr
        : '${displayMonths!} Months';

    return Container(
      height: 180.h,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 12.w, 20.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        image: DecorationImage(
          scale: 1.5,
          image: AssetImage(AssetImages.back1),
          fit: BoxFit.fitWidth,
        ),
        gradient: const LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xff026299), Color(0xff0383C7)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            monthsLabel,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
          8.verticalSpace,
          Text(
            'retainer_replacement_soon'.tr,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.borderLightBlue.withValues(alpha: 0.5),
              height: 1.35,
            ),
          ),
          12.verticalSpace,
          GestureDetector(
            onTap: onOrderNow ?? () => Get.to(() => const CheckoutScreen()),
            child: Text(
              'order_now'.tr,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.whiteColor,
                decoration: TextDecoration.underline,
                decorationColor: AppColor.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WornProgressCircle extends StatelessWidget {
  const _WornProgressCircle({
    required this.progress,
    required this.todaySeconds,
    required this.marking,
    required this.onMarkWorn,
  });

  final double progress;
  final int todaySeconds;
  final bool marking;
  final VoidCallback onMarkWorn;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: marking ? null : onMarkWorn,
      child: SizedBox(
        height: 240.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 220.w,
              height: 220.w,
              child: CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 14.w,
                backgroundColor: AppColor.profileOptionBg,
                color: AppColor.primaryBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                color: AppColor.profileOptionBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: marking
                    ? const CircularProgressIndicator()
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'mark_as_worn'.tr,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textDark,
                            ),
                          ),
                          8.verticalSpace,
                          Text(
                            ApiMap.formatSeconds(todaySeconds),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColor.textBody,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key, this.quote});

  final String? quote;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.format_quote_rounded,
            color: AppColor.primaryBlue,
            size: 20.sp,
          ),
        ),
        12.horizontalSpace,
        Expanded(
          child: Text(
            quote ?? 'home_quote'.tr,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.blackColor,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _EducationalTipsSection extends StatelessWidget {
  const _EducationalTipsSection({required this.tips});

  final List<EducationalTip> tips;

  @override
  Widget build(BuildContext context) {
    final items = tips.isEmpty ? EducationalTipsData.tips : tips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'educational_tips'.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => Get.to(() => const EducationalTipsScreen()),
              child: Text(
                'see_all'.tr,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColor.textBody,
                  decorationThickness: 1.5,
                  decorationStyle: TextDecorationStyle.solid,
                ),
              ),
            ),
          ],
        ),
        16.verticalSpace,
        SizedBox(
          height: 290.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final tip = items[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == items.length - 1 ? 0 : 14.w,
                ),
                child: EducationalTipHorizontalCard(
                  tip: tip,
                  onTap: () {
                    Get.to(() => EducationalTipDetailScreen(tip: tip));
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavPlaceholderScreen extends StatelessWidget {
  const _NavPlaceholderScreen({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColor.textDark,
        ),
      ),
    );
  }
}

Widget buildNavPlaceholder(String title) => _NavPlaceholderScreen(title: title);
