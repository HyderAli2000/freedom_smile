import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/add_reminder_home.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/profile_widgets.dart';
import 'package:freedom_smile/widgets/profile/reminder_set_dialog.dart';
import 'package:freedom_smile/widgets/profile/set_clock_bottom_sheet.dart';
import 'package:get/get.dart';

class SetReminderHome extends StatefulWidget {
  const SetReminderHome({super.key});

  @override
  State<SetReminderHome> createState() => _SetReminderHomeState();
}

class _SetReminderHomeState extends State<SetReminderHome> {
  final _userService = UserService();

  bool _loading = true;
  bool _saving = false;
  bool _editMode = false;
  int? _selectedIndex;
  List<Map<String, dynamic>> _reminders = const [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    try {
      final result = await _userService.listReminders();
      final data = ApiMap.map(result.data);
      final reminders = ApiMap.mapList(data, 'reminders');
      if (mounted) {
        setState(() {
          _reminders = reminders;
          if (_selectedIndex != null &&
              _selectedIndex! >= _reminders.length) {
            _selectedIndex = _reminders.isEmpty ? null : 0;
          } else if (_selectedIndex == null && _reminders.isNotEmpty) {
            _selectedIndex = 0;
          }
        });
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep empty state.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openAddReminder() async {
    await Get.to(() => const AddReminderHome());
    if (!mounted) return;
    setState(() => _loading = true);
    await _loadReminders();
  }

  String _summaryText(Map<String, dynamic> r) {
    final time = ApiMap.str(r['time'], '10:00');
    final period = ApiMap.str(r['period'], 'PM').toUpperCase();
    final type = ApiMap.str(r['type'], 'night').toLowerCase();
    final typeLabel = switch (type) {
      'morning' => 'Morning',
      'custom' || 'customtime' || 'custom_time' => 'Custom',
      _ => 'Night',
    };
    return '$time $period ($typeLabel)';
  }

  String _iconAsset(Map<String, dynamic> r) {
    final type = ApiMap.str(r['type'], 'night').toLowerCase();
    if (type == 'morning') return AssetIcons.morning;
    if (type.contains('custom')) return AssetIcons.custom;
    return AssetIcons.night;
  }

  int _hourOf(Map<String, dynamic> r) {
    final time = ApiMap.str(r['time'], '10:00');
    final parts = time.split(':');
    return int.tryParse(parts.first) ?? 10;
  }

  int _minuteOf(Map<String, dynamic> r) {
    final time = ApiMap.str(r['time'], '10:00');
    final parts = time.split(':');
    if (parts.length < 2) return 0;
    return int.tryParse(parts[1]) ?? 0;
  }

  bool _isAmOf(Map<String, dynamic> r) {
    final period = ApiMap.str(r['period'], 'PM').toUpperCase();
    return period == 'AM';
  }

  Map<String, dynamic>? get _selectedReminder {
    final i = _selectedIndex;
    if (i == null || i < 0 || i >= _reminders.length) return null;
    return _reminders[i];
  }

  Future<void> _editReminder(Map<String, dynamic> reminder) async {
    final id = ApiMap.id(reminder);
    if (id.isEmpty) {
      ApiSnackbar.error('Reminder not found');
      return;
    }

    SetClockBottomSheet.show(
      context,
      mode: ReminderClockMode.edit,
      initialHour: _hourOf(reminder),
      initialMinute: _minuteOf(reminder),
      initialIsAm: _isAmOf(reminder),
      initialEnabled: ApiMap.boolVal(reminder['isEnabled'], true),
      onNext: (value) async {
        Navigator.of(context).pop();
        setState(() => _saving = true);
        try {
          final type = ApiMap.str(reminder['type'], 'night');
          final result = await _userService.updateReminder(id, {
            'type': type,
            'time': value.time,
            'period': value.period,
            'isEnabled': value.isEnabled,
          });
          ApiSnackbar.success(result.message);
          await _loadReminders();
          if (!mounted) return;
          setState(() => _editMode = false);
          ReminderSetDialog.show(
            context,
            type: ReminderDialogType.updated,
            onContinue: () {},
          );
        } on ApiException catch (e) {
          ApiSnackbar.fromException(e);
        } catch (_) {
          // Ignore.
        } finally {
          if (mounted) setState(() => _saving = false);
        }
      },
    );
  }

  Future<void> _deleteReminder(Map<String, dynamic> reminder) async {
    final id = ApiMap.id(reminder);
    if (id.isEmpty) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('edit'.tr),
        content: const Text('Delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _saving = true);
    try {
      final result = await _userService.deleteReminder(id);
      ApiSnackbar.success(result.message);
      await _loadReminders();
      if (mounted) setState(() => _editMode = false);
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Ignore.
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _onEditPressed() async {
    if (_reminders.isEmpty) {
      await _openAddReminder();
      return;
    }

    // First press: enter edit mode (tap card to edit / delete).
    // If a card is already selected, open its editor immediately.
    if (!_editMode) {
      final selected = _selectedReminder;
      if (selected != null) {
        await _editReminder(selected);
        return;
      }
      setState(() {
        _editMode = true;
        _selectedIndex ??= 0;
      });
      return;
    }

    final selected = _selectedReminder;
    if (selected == null) {
      ApiSnackbar.error('Select a reminder to edit');
      return;
    }
    await _editReminder(selected);
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
                PageHeader(title: 'set_reminder'.tr, whiteBackButton: true),
                20.verticalSpace,
                if (_loading || _saving)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  Text(
                    'reminder'.tr,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textBody,
                    ),
                  ),
                  10.verticalSpace,
                  Expanded(
                    child: _reminders.isEmpty
                        ? Center(
                            child: Text(
                              'No reminder set',
                              style: TextStyle(
                                fontFamily: AppFonts.family,
                                fontFamilyFallback: AppFonts.fallback,
                                fontSize: 14.sp,
                                color: AppColor.textBody,
                              ),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _reminders.length,
                            separatorBuilder: (_, __) => 12.verticalSpace,
                            itemBuilder: (context, index) {
                              final reminder = _reminders[index];
                              final selected = _selectedIndex == index;
                              return _ReminderSummaryCard(
                                summary: _summaryText(reminder),
                                iconAsset: _iconAsset(reminder),
                                selected: selected || _editMode,
                                editMode: _editMode,
                                onTap: () {
                                  setState(() => _selectedIndex = index);
                                  if (_editMode) {
                                    _editReminder(reminder);
                                  }
                                },
                                onDelete: _editMode
                                    ? () => _deleteReminder(reminder)
                                    : null,
                              );
                            },
                          ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: FloatingActionButton(
                        onPressed: _openAddReminder,
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
                      label: _editMode ? 'done'.tr : 'edit'.tr,
                      onPressed: () async {
                        if (_editMode) {
                          setState(() => _editMode = false);
                          return;
                        }
                        await _onEditPressed();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReminderSummaryCard extends StatelessWidget {
  const _ReminderSummaryCard({
    required this.summary,
    required this.iconAsset,
    this.selected = false,
    this.editMode = false,
    this.onTap,
    this.onDelete,
  });

  final String summary;
  final String iconAsset;
  final bool selected;
  final bool editMode;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: selected
                  ? AppColor.primaryBlue
                  : AppColor.borderLightBlue.withValues(alpha: 0.5),
              width: selected ? 1.8 : 1,
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
                  iconAsset,
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
                      'your_reminder'.tr,
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
                      summary,
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
              if (editMode && onDelete != null)
                IconButton(
                  onPressed: onDelete,
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.red.shade600,
                    size: 22.sp,
                  ),
                )
              else if (editMode)
                Icon(
                  Icons.edit_outlined,
                  color: AppColor.primaryBlue,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
