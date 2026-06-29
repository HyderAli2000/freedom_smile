import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class AppHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AppHomeAppBar({
    super.key,
    this.userName = 'Anderson',
    this.subtitle = 'Keep a Healthy Smile',
    this.onNotificationTap,
  });

  final String userName;
  final String subtitle;
  final VoidCallback? onNotificationTap;

  @override
  Size get preferredSize => Size.fromHeight(72.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      toolbarHeight: 72.h,
      titleSpacing: 0,
      title: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.primaryBlue,
              ),
              child: CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColor.profileOptionBg,
                backgroundImage: AssetImage(AssetImages.p1),
              ),
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hi, $userName',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textDark,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onNotificationTap,
              child: Container(
                width: 44.w,
                height: 44.w,
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColor.whiteColor,
                  border: Border.all(
                    color: AppColor.primaryBlue.withValues(alpha: 0.25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Image.asset(
                  AssetIcons.notii,
                  color: AppColor.primaryBlue,
                  width: 22.w,
                  height: 22.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
