import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/clinic/clinic_bottom_sheet.dart';

/// Center (+) map tab — design map image + API clinics on markers.
class AddMapHome extends StatefulWidget {
  const AddMapHome({super.key});

  @override
  State<AddMapHome> createState() => _AddMapHomeState();
}

class _AddMapHomeState extends State<AddMapHome> {
  final _service = UserService();

  bool _loading = true;
  List<_ClinicPin> _clinics = const [];

  /// Same marker layout used in the UI phase.
  static const _markerPositions = <Offset>[
    Offset(0.22, 0.38),
    Offset(0.48, 0.32),
    Offset(0.72, 0.44),
    Offset(0.34, 0.54),
    Offset(0.58, 0.60),
    Offset(0.18, 0.66),
    Offset(0.82, 0.52),
    Offset(0.65, 0.28),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Postman: GET /user/orthodontists
      final result = await _service.listOrthodontists();
      final rows = ApiMap.mapList(result.data, 'orthodontists');
      if (mounted) {
        setState(() {
          _clinics = rows.map(_ClinicPin.fromMap).toList();
          _loading = false;
        });
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openClinic(_ClinicPin clinic) {
    return showClinicScheduleBottomSheet(
      context,
      orthodontistId: clinic.id,
      orthodontistName: clinic.name,
      appointmentSource: 'general',
    );
  }

  @override
  Widget build(BuildContext context) {
    final markerCount = _clinics.isEmpty
        ? 0
        : _markerPositions.length.clamp(0, _clinics.length);

    return Stack(
      fit: StackFit.expand,
      children: [
        // Design-phase map artwork
        Image.asset(AssetImages.map, fit: BoxFit.cover),
        if (_loading)
          const Center(child: CircularProgressIndicator())
        else ...[
          ...List.generate(markerCount, (index) {
            final pos = _markerPositions[index];
            final clinic = _clinics[index];
            return Positioned(
              left: pos.dx * 1.sw - 20.r,
              top: pos.dy * 1.sh - 20.r,
              child: GestureDetector(
                onTap: () => _openClinic(clinic),
                child: const _MapClinicMarker(),
              ),
            );
          }),
          if (_clinics.isEmpty)
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 32.w),
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Text(
                  'No clinics found',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textDark,
                  ),
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _ClinicPin {
  const _ClinicPin({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory _ClinicPin.fromMap(Map<String, dynamic> map) {
    return _ClinicPin(
      id: ApiMap.id(map),
      name: ApiMap.str(map['name'], 'Orthodontist'),
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
