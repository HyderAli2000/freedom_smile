import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/book_appointment_user.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/clinic/clinic_bottom_sheet.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

/// Map screen — select a clinic marker, Continue, then clinic bottom sheet.
class ReEvaluationMapUser extends StatefulWidget {
  const ReEvaluationMapUser({super.key});

  @override
  State<ReEvaluationMapUser> createState() => _ReEvaluationMapUserState();
}

class _ReEvaluationMapUserState extends State<ReEvaluationMapUser> {
  int? _selectedBuildingIndex;
  bool _showClinicSheet = false;

  static const _buildingPositions = <Offset>[
    Offset(0.22, 0.24),
    Offset(0.48, 0.18),
    Offset(0.72, 0.30),
    Offset(0.34, 0.40),
    Offset(0.58, 0.46),
    Offset(0.18, 0.52),
  ];
  void _onBuildingTap(int index) {
    setState(() => _selectedBuildingIndex = index);
  }

  void _onContinue() {
    if (_selectedBuildingIndex == null) return;
    setState(() => _showClinicSheet = true);
  }

  void _onBack() {
    if (_showClinicSheet) {
      setState(() => _showClinicSheet = false);
      return;
    }
    Get.back<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AssetImages.map, fit: BoxFit.cover),
          ...List.generate(_buildingPositions.length, (index) {
            final pos = _buildingPositions[index];
            final selected = _selectedBuildingIndex == index;
            return Positioned(
              left: pos.dx * 1.sw,
              top: pos.dy * 1.sh,
              child: _BuildingMarker(
                selected: selected,
                onTap: () => _onBuildingTap(index),
              ),
            );
          }),
          Positioned(
            top: 20.h,
            left: 0,
            right: 0,
            child: PageHeader(
              title: 'Select Near-by Orthodontist',
              onBack: _onBack,
              whiteBackButton: true,
            ),
          ),
          if (!_showClinicSheet)
            Positioned(
              left: 20.w,
              right: 20.w,
              bottom: 28.h,
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _selectedBuildingIndex != null
                      ? _onContinue
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: AppColor.whiteColor,
                    disabledBackgroundColor: AppColor.primaryBlue.withValues(
                      alpha: 0.45,
                    ),
                    disabledForegroundColor: AppColor.whiteColor,
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.whiteColor,
                    ),
                  ),
                ),
              ),
            ),
          if (_showClinicSheet)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: ClinicBottomSheet(
                onSchedule: () => Get.to(() => const BookAppointmentUser()),
              ),
            ),
        ],
      ),
    );
  }
}

class _BuildingMarker extends StatelessWidget {
  const _BuildingMarker({required this.selected, required this.onTap});

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
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColor.calendarBg : AppColor.primaryBlue,
            border: Border.all(
              color: selected ? AppColor.whiteColor : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColor.primaryBlue.withValues(alpha: 0.35),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(8.w),
          child: Image.asset(
            AssetIcons.building,
            color: AppColor.whiteColor,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
