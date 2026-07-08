import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:get/get.dart';

enum ReminderClockMode { add, edit }

class SetClockBottomSheet extends StatefulWidget {
  const SetClockBottomSheet({
    super.key,
    required this.onNext,
    this.mode = ReminderClockMode.add,
    this.initialHour = 7,
    this.initialMinute = 0,
    this.initialIsAm = true,
  });

  final VoidCallback onNext;
  final ReminderClockMode mode;
  final int initialHour;
  final int initialMinute;
  final bool initialIsAm;

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onNext,
    ReminderClockMode mode = ReminderClockMode.add,
    int initialHour = 7,
    int initialMinute = 0,
    bool initialIsAm = true,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SetClockBottomSheet(
        onNext: onNext,
        mode: mode,
        initialHour: initialHour,
        initialMinute: initialMinute,
        initialIsAm: initialIsAm,
      ),
    );
  }

  @override
  State<SetClockBottomSheet> createState() => _SetClockBottomSheetState();
}

class _SetClockBottomSheetState extends State<SetClockBottomSheet> {
  late int _hour;
  late int _minute;
  late bool _isAm;
  bool _dailyReminderEnabled = true;

  @override
  void initState() {
    super.initState();
    _hour = widget.initialHour;
    _minute = widget.initialMinute;
    _isAm = widget.initialIsAm;
  }

  void _selectHour(int hour) {
    setState(() => _hour = hour);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.mode == ReminderClockMode.edit;
    final title = isEdit ? 'edit_reminder'.tr : 'set_clock'.tr;
    final actionLabel = isEdit ? 'save'.tr : 'next'.tr;

    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
            16.verticalSpace,
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.whiteColor,
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                Text(
                  'daily_reminder'.tr,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.whiteColor,
                  ),
                ),
                const Spacer(),
                Switch(
                  padding: EdgeInsets.zero,
                  value: _dailyReminderEnabled,
                  onChanged: (value) {
                    setState(() => _dailyReminderEnabled = value);
                  },

                  activeThumbColor: AppColor.whiteColor,
                  activeTrackColor: AppColor.blackColor,
                  inactiveThumbColor: AppColor.blackColor,
                  inactiveTrackColor: AppColor.whiteColor,
                ),
              ],
            ),
            16.verticalSpace,
            Column(
              children: [
                Container(
                  padding: EdgeInsets.all(14.w),
                  decoration: BoxDecoration(
                    color: AppColor.blackColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14.r),
                      topRight: Radius.circular(14.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _TimeBox(text: '$_hour'),
                      10.horizontalSpace,
                      _TimeBox(text: _minute.toString().padLeft(2, '0')),
                      14.horizontalSpace,
                      Column(
                        children: [
                          _AmPmBox(
                            label: 'am'.tr,
                            isSelected: _isAm,
                            onTap: () => setState(() => _isAm = true),
                          ),
                          6.verticalSpace,
                          _AmPmBox(
                            label: 'pm'.tr,
                            isSelected: !_isAm,
                            onTap: () => setState(() => _isAm = false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14.r),
                      bottomRight: Radius.circular(14.r),
                    ),
                  ),
                  child: Center(
                    child: _AnalogClockFace(
                      selectedHour: _hour,
                      onHourSelected: _selectHour,
                    ),
                  ),
                ),
              ],
            ),
            24.verticalSpace,
            SizedBox(
              width: double.infinity,
              height: 52.h,
              child: ElevatedButton(
                onPressed: widget.onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.whiteColor,
                  foregroundColor: AppColor.primaryBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.primaryBlue,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  const _TimeBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52.w,
      height: 52.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColor.whiteColor.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.w700,
          color: AppColor.whiteColor,
        ),
      ),
    );
  }
}

class _AmPmBox extends StatelessWidget {
  const _AmPmBox({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.whiteColor
              : AppColor.whiteColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.primaryBlue : AppColor.whiteColor,
          ),
        ),
      ),
    );
  }
}

class _AnalogClockFace extends StatelessWidget {
  const _AnalogClockFace({
    required this.selectedHour,
    required this.onHourSelected,
  });

  final int selectedHour;
  final ValueChanged<int> onHourSelected;

  @override
  Widget build(BuildContext context) {
    final size = 220.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColor.primaryBlue,
              shape: BoxShape.circle,
            ),
          ),
          ...List.generate(12, (index) {
            final hour = index + 1;
            final angle = (hour * 30 - 90) * math.pi / 180;
            final radius = size * 0.36;
            final isSelected = hour == selectedHour;

            return Positioned(
              left: size / 2 + radius * math.cos(angle) - 16.w,
              top: size / 2 + radius * math.sin(angle) - 16.w,
              child: GestureDetector(
                onTap: () => onHourSelected(hour),
                child: Container(
                  width: 32.w,
                  height: 32.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.whiteColor
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$hour',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColor.primaryBlue
                          : AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            );
          }),
          Transform.rotate(
            angle: (selectedHour % 12) * math.pi / 6,
            child: Container(
              width: 4.w,
              height: size * 0.28,
              margin: EdgeInsets.only(bottom: size * 0.28),
              decoration: BoxDecoration(
                color: AppColor.whiteColor,
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
