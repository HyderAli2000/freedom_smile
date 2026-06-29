import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/add_reminder_home.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';
import 'package:freedom_smile/widgets/profile/reminder_set_dialog.dart';
import 'package:freedom_smile/widgets/profile/set_clock_bottom_sheet.dart';
import 'package:get/get.dart';

class SetReminderHome extends StatelessWidget {
  const SetReminderHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeader(title: 'Set Reminder', whiteBackButton: true),
                20.verticalSpace,
                Text(
                  'Reminder',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.textBody,
                  ),
                ),
                10.verticalSpace,
                const _ReminderSummaryCard(),
                const Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: FloatingActionButton(
                      onPressed: () => Get.to(() => const AddReminderHome()),
                      backgroundColor: AppColor.primaryBlue,
                      elevation: 4,
                      shape: const CircleBorder(),
                      child: Icon(
                        Icons.add_rounded,
                        color: AppColor.whiteColor,
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: ProfilePrimaryButton(
                    label: 'Edit',
                    onPressed: () {
                      SetClockBottomSheet.show(
                        context,
                        mode: ReminderClockMode.edit,
                        initialHour: 10,
                        initialIsAm: false,
                        onNext: () {
                          Navigator.of(context).pop();
                          ReminderSetDialog.show(
                            context,
                            type: ReminderDialogType.updated,
                            onContinue: () => Get.close(1),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderSummaryCard extends StatelessWidget {
  const _ReminderSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColor.profileOptionBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: const BoxDecoration(
              color: AppColor.primaryBlue,
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(10.w),
            child: Image.asset(
              AssetIcons.night,
              color: AppColor.whiteColor,
              fit: BoxFit.contain,
            ),
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Reminder',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textDark,
                  ),
                ),
                4.verticalSpace,
                Text(
                  '10:00 PM (Night)',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textBody,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
