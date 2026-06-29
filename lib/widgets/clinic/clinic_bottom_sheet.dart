import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/book_appointment_user.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

Future<void> showClinicScheduleBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => ClinicBottomSheet(
      onSchedule: () {
        Navigator.of(sheetContext).pop();
        Get.to(() => const BookAppointmentUser());
      },
    ),
  );
}

class ClinicBottomSheet extends StatelessWidget {
  const ClinicBottomSheet({super.key, required this.onSchedule});

  final VoidCallback onSchedule;

  static const _description =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 0.62.sh),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 100.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(AssetImages.pc4, fit: BoxFit.cover),
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Lorem Ipsum Orthodontist',
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xffF5A623),
                    size: 18.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '4.7 (50+)',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            _description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              height: 1.45,
              color: AppColor.whiteColor.withValues(alpha: 0.88),
            ),
          ),
          SizedBox(height: 18.h),
          Material(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(9999),
            child: InkWell(
              onTap: onSchedule,
              borderRadius: BorderRadius.circular(9999),
              child: SizedBox(
                height: 52.h,
                child: Center(
                  child: Text(
                    'Schedule Appointment',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textDark,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
