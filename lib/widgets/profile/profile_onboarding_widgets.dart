import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class ProfileOnboardingScaffold extends StatelessWidget {
  const ProfileOnboardingScaffold({
    super.key,
    required this.title,
    required this.stepText,
    required this.child,
    required this.onNext,
    this.onSkip,
  });

  final String title;
  final String stepText;
  final Widget child;
  final VoidCallback onNext;
  final VoidCallback? onSkip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              ProfileOnboardingHeader(title: title, stepText: stepText),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                  child: child,
                ),
              ),
              ProfileOnboardingFooter(onSkip: onSkip ?? onNext, onNext: onNext),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOnboardingHeader extends StatelessWidget {
  const ProfileOnboardingHeader({
    super.key,
    required this.title,
    required this.stepText,
  });

  final String title;
  final String stepText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.primaryBlue,
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColor.primaryBlue, width: 1.5),
                  ),
                  child: Icon(
                    Icons.chevron_left_rounded,
                    color: AppColor.primaryBlue,
                    size: 26.sp,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                stepText,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileOnboardingFooter extends StatelessWidget {
  const ProfileOnboardingFooter({
    super.key,
    required this.onSkip,
    required this.onNext,
  });

  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
      child: Column(
        children: [
          GestureDetector(
            onTap: onSkip,
            child: Text(
              'Skip',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.primaryBlue,
                decoration: TextDecoration.underline,
                decorationColor: AppColor.primaryBlue,
              ),
            ),
          ),
          16.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryBlue,
                foregroundColor: AppColor.whiteColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColor.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileQuestionTitle extends StatelessWidget {
  const ProfileQuestionTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColor.primaryBlue,
        height: 1.35,
      ),
    );
  }
}

class ProfileOptionButton extends StatelessWidget {
  const ProfileOptionButton({
    super.key,
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
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 25.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColor.primaryBlue : AppColor.profileOptionBg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(
              alpha: isSelected ? 1 : 0.35,
            ),
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColor.whiteColor : AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class ProfileYearSelector extends StatelessWidget {
  const ProfileYearSelector({
    super.key,
    required this.year,
    required this.onPrevious,
    required this.onNext,
  });

  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          _YearArrowButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          Expanded(
            child: Text(
              '$year',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.whiteColor,
              ),
            ),
          ),
          _YearArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    );
  }
}

class _YearArrowButton extends StatelessWidget {
  const _YearArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColor.whiteColor, size: 24.sp),
    );
  }
}

class ProfileCalendarPicker extends StatelessWidget {
  const ProfileCalendarPicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  static const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    final daysInMonth = DateTime(
      selectedDate.year,
      selectedDate.month + 1,
      0,
    ).day;
    final startWeekday = firstDayOfMonth.weekday;
    final leadingEmpty = startWeekday - 1;

    return Container(
      padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
      decoration: BoxDecoration(
        color: AppColor.calendarBg,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _CalendarArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: onPreviousMonth,
              ),
              Expanded(
                child: Text(
                  '${_months[selectedDate.month - 1]} ${selectedDate.year}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              _CalendarArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: onNextMonth,
              ),
            ],
          ),
          14.verticalSpace,
          Row(
            children: _weekdays
                .map(
                  (day) => Expanded(
                    child: Text(
                      day,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.calendarDayMuted,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          10.verticalSpace,
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leadingEmpty + daysInMonth,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemBuilder: (context, index) {
              if (index < leadingEmpty) return const SizedBox.shrink();

              final day = index - leadingEmpty + 1;
              final date = DateTime(selectedDate.year, selectedDate.month, day);
              final isSelected =
                  date.year == selectedDate.year &&
                  date.month == selectedDate.month &&
                  date.day == selectedDate.day;

              return GestureDetector(
                onTap: () => onDateSelected(date),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColor.calendarSelectedDay
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarArrowButton extends StatelessWidget {
  const _CalendarArrowButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: AppColor.whiteColor, size: 22.sp),
    );
  }
}

class ProfileReminderCard extends StatelessWidget {
  const ProfileReminderCard({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
  });

  final String label;
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 130.h,
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColor.profileOptionBg
                : AppColor.whiteColor.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.primaryBlue.withValues(
                alpha: isSelected ? 1 : 0.35,
              ),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                icon,
                color: AppColor.primaryBlue,
                width: 34.w,
                height: 34.h,
              ),
              10.verticalSpace,
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColor.primaryBlue,
                ),
              ),
              if (subtitle != null) ...[
                4.verticalSpace,
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColor.primaryBlue.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
