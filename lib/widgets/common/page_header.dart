import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:get/get.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    this.title,
    this.showTitle = true,
    this.onBack,
    this.whiteBackButton = false,
  });

  final String? title;
  final bool showTitle;
  final VoidCallback? onBack;
  final bool whiteBackButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.w, 8.h, 16.w, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (showTitle && title != null)
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.blackColor,
              ),
            ),
          Row(
            children: [
              GestureDetector(
                onTap: onBack ?? Get.back,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: whiteBackButton
                        ? AppColor.whiteColor.withValues(alpha: 0.92)
                        : null,
                    border: Border.all(color: AppColor.primaryBlue, width: 1.5),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColor.primaryBlue,
                    size: 26.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
