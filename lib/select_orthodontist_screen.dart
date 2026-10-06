import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/book_appointment_user.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

/// Select Near-by Orthodontist — same design map as the + tab.
class SelectOrthodontistScreen extends StatefulWidget {
  const SelectOrthodontistScreen({
    super.key,
    this.appointmentSource = 'general',
  });

  /// Backend book source: `general` | `reevaluation`.
  final String appointmentSource;

  @override
  State<SelectOrthodontistScreen> createState() =>
      _SelectOrthodontistScreenState();
}

class _SelectOrthodontistScreenState extends State<SelectOrthodontistScreen> {
  final _service = UserService();

  bool _loading = true;
  List<_OrthoClinic> _clinics = const [];
  String? _selectedId;

  /// Same marker layout as AddMapHome / UI phase.
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
    _loadOrthodontists();
  }

  Future<void> _loadOrthodontists() async {
    setState(() => _loading = true);
    try {
      // Postman: GET /user/orthodontists
      final result = await _service.listOrthodontists();
      final rows = ApiMap.mapList(result.data, 'orthodontists');
      final clinics = rows.map(_OrthoClinic.fromMap).toList();
      if (mounted) {
        setState(() {
          _clinics = clinics;
          if (_clinics.isNotEmpty) {
            _selectedId ??= _clinics.first.id;
          }
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

  void _continue() {
    final id = _selectedId;
    if (id == null || id.isEmpty) {
      ApiSnackbar.error('Please select an orthodontist');
      return;
    }
    final clinic = _clinics.where((c) => c.id == id).firstOrNull;
    Get.to(
      () => BookAppointmentUser(
        orthodontistId: id,
        orthodontistName: clinic?.name,
        source: widget.appointmentSource,
      ),
    );
  }

  _OrthoClinic? get _selectedClinic =>
      _clinics.where((c) => c.id == _selectedId).firstOrNull;

  @override
  Widget build(BuildContext context) {
    final markerCount = _clinics.isEmpty
        ? 0
        : _markerPositions.length.clamp(0, _clinics.length);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AssetImages.map, fit: BoxFit.cover),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else ...[
            ...List.generate(markerCount, (index) {
              final pos = _markerPositions[index];
              final clinic = _clinics[index];
              final selected = clinic.id == _selectedId;
              return Positioned(
                left: pos.dx * 1.sw - 20.r,
                top: pos.dy * 1.sh - 20.r,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedId = clinic.id),
                  child: _OrthodontistMapMarker(selected: selected),
                ),
              );
            }),
          ],
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColor.whiteColor.withValues(alpha: 0.92),
                  child: const PageHeader(
                    title: 'Select Near-by Orthodontist',
                  ),
                ),
                const Spacer(),
                if (!_loading && _clinics.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.w),
                    child: Container(
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
                if (_selectedClinic != null)
                  _SelectedClinicBanner(clinic: _selectedClinic),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _loading || _clinics.isEmpty ? null : _continue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.whiteColor,
                        disabledBackgroundColor:
                            AppColor.primaryBlue.withValues(alpha: 0.45),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrthoClinic {
  const _OrthoClinic({
    required this.id,
    required this.name,
    required this.address,
    required this.city,
    required this.rating,
  });

  final String id;
  final String name;
  final String address;
  final String city;
  final double rating;

  factory _OrthoClinic.fromMap(Map<String, dynamic> map) {
    return _OrthoClinic(
      id: ApiMap.id(map),
      name: ApiMap.str(map['name'], 'Orthodontist'),
      address: ApiMap.str(map['address']),
      city: ApiMap.str(map['city']),
      rating: ApiMap.doubleVal(map['rating']),
    );
  }
}

class _SelectedClinicBanner extends StatelessWidget {
  const _SelectedClinicBanner({this.clinic});

  final _OrthoClinic? clinic;

  @override
  Widget build(BuildContext context) {
    if (clinic == null) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clinic!.name,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColor.textDark,
                    ),
                  ),
                  2.verticalSpace,
                  Text(
                    [
                      clinic!.address,
                      clinic!.city,
                    ].where((e) => e.isNotEmpty).join(', '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 12.sp,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
            ),
            if (clinic!.rating > 0)
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFB800),
                    size: 16.sp,
                  ),
                  4.horizontalSpace,
                  Text(
                    clinic!.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColor.textBody,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _OrthodontistMapMarker extends StatelessWidget {
  const _OrthodontistMapMarker({this.selected = false});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: selected ? AppColor.calendarBg : AppColor.primaryBlue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.primaryBlue.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: selected
            ? Border.all(color: AppColor.whiteColor, width: 2)
            : null,
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
