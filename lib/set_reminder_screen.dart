import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/profile/profile_onboarding_widgets.dart';
import 'package:freedom_smile/widgets/profile/reminder_set_dialog.dart';
import 'package:freedom_smile/widgets/profile/set_clock_bottom_sheet.dart';
import 'package:get/get.dart';

enum ReminderType { nightTime, morning, customTime }

class SetReminderScreen extends StatefulWidget {
  const SetReminderScreen({super.key});

  @override
  State<SetReminderScreen> createState() => _SetReminderScreenState();
}

class _SetReminderScreenState extends State<SetReminderScreen> {
  ReminderType _selectedReminder = ReminderType.nightTime;

  int _defaultHourFor(ReminderType type) {
    switch (type) {
      case ReminderType.nightTime:
        return 9;
      case ReminderType.morning:
        return 7;
      case ReminderType.customTime:
        return 7;
    }
  }

  bool _defaultIsAmFor(ReminderType type) {
    switch (type) {
      case ReminderType.nightTime:
        return false;
      case ReminderType.morning:
        return true;
      case ReminderType.customTime:
        return true;
    }
  }

  void _onReminderSelected(ReminderType type) {
    setState(() => _selectedReminder = type);
    _showSetClockSheet(type);
  }

  void _showSetClockSheet(ReminderType type) {
    SetClockBottomSheet.show(
      context,
      initialHour: _defaultHourFor(type),
      initialIsAm: _defaultIsAmFor(type),
      onNext: () {
        Navigator.of(context).pop();
        ReminderSetDialog.show(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ProfileOnboardingScaffold(
      title: 'new_reminder'.tr,
      stepText: 'step_4_of_5'.tr,
      onNext: () => _showSetClockSheet(_selectedReminder),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileQuestionTitle(text: 'what_time_remind_you'.tr),
          8.verticalSpace,
          Text(
            'reminder_change_later_hint'.tr,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
            ),
          ),
          24.verticalSpace,
          Row(
            children: [
              ProfileReminderCard(
                label: 'night_time'.tr,
                subtitle: 'recommend'.tr,
                icon: AssetIcons.night,
                isSelected: _selectedReminder == ReminderType.nightTime,
                onTap: () => _onReminderSelected(ReminderType.nightTime),
              ),
              10.horizontalSpace,
              ProfileReminderCard(
                label: 'morning'.tr,
                icon: AssetIcons.morning,
                isSelected: _selectedReminder == ReminderType.morning,
                onTap: () => _onReminderSelected(ReminderType.morning),
              ),
              10.horizontalSpace,
              ProfileReminderCard(
                label: 'custom_time'.tr,
                icon: AssetIcons.custom,
                isSelected: _selectedReminder == ReminderType.customTime,
                onTap: () => _onReminderSelected(ReminderType.customTime),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
