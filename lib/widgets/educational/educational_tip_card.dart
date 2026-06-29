import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/utils/app_colors.dart';

class EducationalTipListCard extends StatelessWidget {
  const EducationalTipListCard({
    super.key,
    required this.tip,
    required this.onTap,
  });

  final EducationalTip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffD2E8F5).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.asset(
                tip.image,
                height: 160.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            14.verticalSpace,
            Text(
              tip.title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
                height: 1.3,
              ),
            ),
            8.verticalSpace,
            Text(
              tip.description,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColor.textBody,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EducationalTipHorizontalCard extends StatelessWidget {
  const EducationalTipHorizontalCard({
    super.key,
    required this.tip,
    required this.onTap,
  });

  final EducationalTip tip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: const Color(0xffD2E8F5).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.asset(
                tip.image,
                height: 120.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            12.verticalSpace,
            Text(
              tip.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
                height: 1.3,
              ),
            ),
            8.verticalSpace,
            Expanded(
              child: Text(
                tip.description,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
