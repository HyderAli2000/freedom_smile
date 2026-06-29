import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/educational_tip_detail_screen.dart';
import 'package:freedom_smile/educational_tips_screen.dart';
import 'package:freedom_smile/retainer_checkin_screen.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/educational/educational_tip_card.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RetainerStatusCard(),
            28.verticalSpace,
            const _WornProgressCircle(),
            28.verticalSpace,
            const QuoteSection(
              quote:
                  'Your smile reflects your care protect it daily with simple habits that make a lasting difference.',
            ),
            28.verticalSpace,
            const _EducationalTipsSection(),
          ],
        ),
      ),
    );
  }
}

class RetainerStatusCard extends StatelessWidget {
  const RetainerStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
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
            '05 Months',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.whiteColor,
            ),
          ),
          8.verticalSpace,
          Text(
            'Your retainer may need\nreplacement soon',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.borderLightBlue.withValues(alpha: 0.5),
              height: 1.35,
            ),
          ),
          12.verticalSpace,
          GestureDetector(
            onTap: () => Get.to(() => const RetainerCheckinScreen()),
            child: Text(
              'Order Now',
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
  const _WornProgressCircle();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220.w,
            height: 220.w,
            child: CircularProgressIndicator(
              value: 0.62,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mark as Worn',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textDark,
                    ),
                  ),
                  8.verticalSpace,
                  Text(
                    '05:21:00',
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
    );
  }
}

class QuoteSection extends StatelessWidget {
  const QuoteSection({super.key, required this.quote});

  final String quote;

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
            quote,
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
  const _EducationalTipsSection();

  @override
  Widget build(BuildContext context) {
    final tips = EducationalTipsData.tips;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              'Educational Tips',
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
                'See All',
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
            itemCount: tips.length,
            itemBuilder: (context, index) {
              final tip = tips[index];
              return Padding(
                padding: EdgeInsets.only(
                  right: index == tips.length - 1 ? 0 : 14.w,
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
