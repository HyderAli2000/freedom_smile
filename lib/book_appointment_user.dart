import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/checkout_screen.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

/// Book appointment — date/time selection then confirmation dialog.
class BookAppointmentUser extends StatefulWidget {
  const BookAppointmentUser({super.key});

  @override
  State<BookAppointmentUser> createState() => _BookAppointmentUserState();
}

class _BookAppointmentUserState extends State<BookAppointmentUser> {
  static const _monthLabel = 'April 2026';
  static const _daysInMonth = 30;
  static const _firstWeekdayOffset = 3; // Wednesday

  int _selectedDay = 25;
  int _selectedTimeIndex = 0;

  static const _timeSlots = ['01:00 PM', '02:00 PM', '05:00 PM'];

  Future<void> _confirmAppointment() async {
    await showAppointmentConfirmedDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeader(title: 'Book Appointment'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textDark,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _CalendarCard(
                          monthLabel: _monthLabel,
                          daysInMonth: _daysInMonth,
                          firstWeekdayOffset: _firstWeekdayOffset,
                          selectedDay: _selectedDay,
                          onDaySelected: (day) =>
                              setState(() => _selectedDay = day),
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Select Time Slot',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textDark,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: List.generate(_timeSlots.length, (index) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: index < _timeSlots.length - 1
                                      ? 10.w
                                      : 0,
                                ),
                                child: _TimeSlotChip(
                                  label: _timeSlots[index],
                                  selected: _selectedTimeIndex == index,
                                  onTap: () => setState(
                                    () => _selectedTimeIndex = index,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 28.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _confirmAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Confirm Appointment',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
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

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.monthLabel,
    required this.daysInMonth,
    required this.firstWeekdayOffset,
    required this.selectedDay,
    required this.onDaySelected,
  });

  final String monthLabel;
  final int daysInMonth;
  final int firstWeekdayOffset;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[];
    for (var i = 0; i < firstWeekdayOffset; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(
        _CalendarDayCell(
          day: day,
          selected: day == selectedDay,
          onTap: () => onDaySelected(day),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColor.calendarBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.chevron_left_rounded,
                color: AppColor.whiteColor,
                size: 24.sp,
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColor.whiteColor,
                size: 24.sp,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: _weekdays
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 10.h),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 4.w,
            children: cells,
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final int day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColor.primaryBlue : Colors.transparent,
          ),
          child: Text(
            '$day',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColor.whiteColor : AppColor.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColor.primaryBlue : AppColor.profileOptionBg,
            borderRadius: BorderRadius.circular(999999999.r),
            border: Border.all(
              color: selected
                  ? AppColor.primaryBlue
                  : AppColor.borderLightBlue.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColor.whiteColor : AppColor.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showAppointmentConfirmedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (dialogContext) => _AppointmentConfirmedDialog(
      onClose: () => Navigator.of(dialogContext).pop(),
      onContinue: () {
        Navigator.of(dialogContext).pop();
        Get.to(() => const CheckoutScreen());
      },
    ),
  );
}

class _AppointmentConfirmedDialog extends StatelessWidget {
  const _AppointmentConfirmedDialog({
    required this.onClose,
    required this.onContinue,
  });

  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          gradient: LinearGradient(
            colors: [
              Color(0xffFFFFFF),
              Color.fromARGB(255, 221, 243, 255),
              Color.fromARGB(255, 190, 232, 255),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Appointment Confirmed',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClose,
                      customBorder: const CircleBorder(),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColor.blackColor.withValues(alpha: 0.55),
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Center(
              child: Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  // color: AppColor.primaryBlue,
                  border: Border.all(color: AppColor.primaryBlue, width: 2),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColor.primaryBlue,
                  size: 36.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "You're all set! You'll receive timely reminders before your visit.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor.withValues(alpha: 0.65),
              ),
            ),
            SizedBox(height: 24.h),
            Material(
              color: AppColor.primaryBlue,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                onTap: onContinue,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 48.h,
                  child: Center(
                    child: Text(
                      'Continue',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.whiteColor,
                      ),
                    ),
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
