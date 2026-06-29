import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/clinic/clinic_bottom_sheet.dart';

/// Map tab body — clinic markers on a static map (navbar index 2).
class AddMapHome extends StatelessWidget {
  const AddMapHome({super.key});

  static const _markerPositions = <Offset>[
    Offset(0.22, 0.38),
    Offset(0.48, 0.32),
    Offset(0.72, 0.44),
    Offset(0.34, 0.54),
    Offset(0.58, 0.60),
    Offset(0.18, 0.66),
    Offset(0.82, 0.52),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(AssetImages.map, fit: BoxFit.cover),
        ...List.generate(_markerPositions.length, (index) {
          final pos = _markerPositions[index];
          return Positioned(
            left: pos.dx * 1.sw,
            top: pos.dy * 1.sh,
            child: GestureDetector(
              onTap: () => showClinicScheduleBottomSheet(context),
              child: const _MapClinicMarker(),
            ),
          );
        }),
      ],
    );
  }
}

class _MapClinicMarker extends StatelessWidget {
  const _MapClinicMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColor.primaryBlue,
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
    );
  }
}
