import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/set_reminder_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/profile_onboarding_widgets.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';
import 'package:freedom_smile/widgets/profile/reminder_set_dialog.dart';
import 'package:freedom_smile/widgets/profile/set_clock_bottom_sheet.dart';
import 'package:get/get.dart';

class AddReminderHome extends StatefulWidget {
  const AddReminderHome({super.key});

  @override
  State<AddReminderHome> createState() => _AddReminderHomeState();
}

class _AddReminderHomeState extends State<AddReminderHome> {
  ReminderType _selectedReminder = ReminderType.nightTime;
  bool _saving = false;

  int _defaultHourFor(ReminderType type) {
    switch (type) {
      case ReminderType.nightTime:
        return 10;
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

  String _apiTypeFor(ReminderType type) {
    switch (type) {
      case ReminderType.nightTime:
        return 'night';
      case ReminderType.morning:
        return 'morning';
      case ReminderType.customTime:
        return 'custom';
    }
  }

  void _onReminderSelected(ReminderType type) {
    setState(() => _selectedReminder = type);
    _showSetClockSheet(type);
  }

  Future<void> _createReminder(
    ReminderType type,
    ReminderClockValue value,
  ) async {
    setState(() => _saving = true);
    try {
      final result = await UserService().createReminder({
        'type': _apiTypeFor(type),
        'time': value.time,
        'period': value.period,
        'isEnabled': value.isEnabled,
      });
      ApiSnackbar.success(result.message);
      if (!mounted) return;
      ReminderSetDialog.show(
        context,
        type: ReminderDialogType.created,
        onContinue: Get.back, // leaves AddReminderHome → list refreshes
      );
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Ignore.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSetClockSheet(ReminderType type) {
    SetClockBottomSheet.show(
      context,
      mode: ReminderClockMode.add,
      initialHour: _defaultHourFor(type),
      initialIsAm: _defaultIsAmFor(type),
      onNext: (value) async {
        Navigator.of(context).pop();
        await _createReminder(type, value);
      },
    );
  }

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
                PageHeader(
                  title: 'new_reminder'.tr,
                  whiteBackButton: true,
                ),
                Expanded(
                  child: _saving
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: EdgeInsets.only(top: 24.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'what_time_remind_you'.tr,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.textDark,
                                  height: 1.35,
                                ),
                              ),
                              8.verticalSpace,
                              Text(
                                'reminder_change_later_hint'.tr,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
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
                                    isSelected: _selectedReminder ==
                                        ReminderType.nightTime,
                                    onTap: () => _onReminderSelected(
                                      ReminderType.nightTime,
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  ProfileReminderCard(
                                    label: 'morning'.tr,
                                    icon: AssetIcons.morning,
                                    isSelected: _selectedReminder ==
                                        ReminderType.morning,
                                    onTap: () => _onReminderSelected(
                                      ReminderType.morning,
                                    ),
                                  ),
                                  10.horizontalSpace,
                                  ProfileReminderCard(
                                    label: 'custom_time'.tr,
                                    icon: AssetIcons.custom,
                                    isSelected: _selectedReminder ==
                                        ReminderType.customTime,
                                    onTap: () => _onReminderSelected(
                                      ReminderType.customTime,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: ProfilePrimaryButton(
                    label: 'next'.tr,
                    onPressed: () {
                      if (_saving) return;
                      _showSetClockSheet(_selectedReminder);
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
