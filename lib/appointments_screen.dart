import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/appointments_data.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/profile/reminder_set_dialog.dart';
import 'package:freedom_smile/widgets/profile/set_clock_bottom_sheet.dart';
import 'package:get/get.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  bool _showCompleted = false;

  List<AppointmentItem> get _filteredItems => AppointmentsData.items
      .where((item) => item.isCompleted == _showCompleted)
      .toList();

  void _openEditReminderSheet(AppointmentItem item) {
    SetClockBottomSheet.show(
      context,
      mode: ReminderClockMode.edit,
      initialHour: item.initialHour,
      initialIsAm: item.initialIsAm,
      onNext: () {
        Navigator.of(context).pop();
        ReminderSetDialog.show(context, type: ReminderDialogType.updated);
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
                PageHeader(title: 'appointments'.tr, whiteBackButton: true),
                20.verticalSpace,
                _AppointmentTabBar(
                  showCompleted: _showCompleted,
                  onChanged: (completed) {
                    setState(() => _showCompleted = completed);
                  },
                ),
                20.verticalSpace,
                Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.only(bottom: 20.h),
                    itemCount: _filteredItems.length,
                    separatorBuilder: (_, __) => 14.verticalSpace,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      return _AppointmentCard(
                        item: item,
                        onTimeTap: () => _openEditReminderSheet(item),
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

class _AppointmentTabBar extends StatelessWidget {
  const _AppointmentTabBar({
    required this.showCompleted,
    required this.onChanged,
  });

  final bool showCompleted;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TabChip(
            label: 'pending'.tr,
            isSelected: !showCompleted,
            onTap: () => onChanged(false),
          ),
        ),
        10.horizontalSpace,
        Expanded(
          child: _TabChip(
            label: 'completed'.tr,
            isSelected: showCompleted,
            onTap: () => onChanged(true),
          ),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColor.primaryBlue
              : AppColor.profileOptionBg.withValues(alpha: 0.85),
          borderRadius: BorderRadius.circular(999.r),
          border: Border.all(
            color: AppColor.primaryBlue.withValues(
              alpha: isSelected ? 1 : 0.35,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColor.whiteColor : AppColor.primaryBlue,
          ),
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({required this.item, required this.onTimeTap});

  final AppointmentItem item;
  final VoidCallback onTimeTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.borderLightBlue.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              item.imageAsset,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textDark,
                        ),
                      ),
                    ),
                    Text(
                      item.id,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textBody,
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Text(
                      'April 20,',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textBody,
                      ),
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: onTimeTap,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primaryBlue,
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Text(
                          item.time,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),

                    10.horizontalSpace,
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB800),
                          size: 18.sp,
                        ),
                        4.horizontalSpace,
                        Text(
                          '${item.rating} (${item.reviewCount})',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textBody,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
