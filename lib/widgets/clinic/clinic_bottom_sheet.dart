import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/book_appointment_user.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/app_network_image.dart';
import 'package:get/get.dart';

Future<void> showClinicScheduleBottomSheet(
  BuildContext context, {
  required String orthodontistId,
  String? orthodontistName,
  String appointmentSource = 'general',
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => ClinicBottomSheet(
      orthodontistId: orthodontistId,
      fallbackName: orthodontistName,
      appointmentSource: appointmentSource,
      onSchedule: (id, name) {
        Navigator.of(sheetContext).pop();
        Get.to(
          () => BookAppointmentUser(
            orthodontistId: id,
            orthodontistName: name,
            source: appointmentSource,
          ),
        );
      },
    ),
  );
}

class ClinicBottomSheet extends StatefulWidget {
  const ClinicBottomSheet({
    super.key,
    required this.orthodontistId,
    required this.onSchedule,
    this.fallbackName,
    this.appointmentSource = 'general',
  });

  final String orthodontistId;
  final String? fallbackName;
  final String appointmentSource;
  final void Function(String id, String name) onSchedule;

  @override
  State<ClinicBottomSheet> createState() => _ClinicBottomSheetState();
}

class _ClinicBottomSheetState extends State<ClinicBottomSheet> {
  bool _loading = true;
  String _name = '';
  String _about = '';
  String _image = AssetImages.pc4;
  double _rating = 0;
  int _ratingCount = 0;

  @override
  void initState() {
    super.initState();
    _name = widget.fallbackName?.trim().isNotEmpty == true
        ? widget.fallbackName!.trim()
        : 'Orthodontist';
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      // Postman: GET /user/orthodontists/:id
      final result = await UserService().orthodontistDetail(widget.orthodontistId);
      final data = ApiMap.map(result.data);
      final ortho = ApiMap.map(data['orthodontist'] ?? data);
      if (!mounted) return;
      setState(() {
        _name = ApiMap.str(ortho['name'], _name);
        _about = ApiMap.str(ortho['about']);
        _image = ApiMap.imageOrFallback(
          ortho['profilePicture'] ?? _firstGallery(ortho),
          AssetImages.pc4,
        );
        _rating = ApiMap.doubleVal(ortho['rating']);
        _ratingCount = ApiMap.intVal(ortho['ratingCount']);
        _loading = false;
      });
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  dynamic _firstGallery(Map<String, dynamic> ortho) {
    final gallery = ortho['gallery'];
    if (gallery is! List || gallery.isEmpty) return null;
    final first = gallery.first;
    if (first is Map) return first['url'] ?? first['image'] ?? first['path'];
    return first;
  }

  Widget _buildHero() {
    if (ApiMap.isNetworkImage(_image)) {
      return AppNetworkImage(
        source: _image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    return Image.asset(_image, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final ratingLabel = _ratingCount > 0
        ? '${_rating.toStringAsFixed(1)} ($_ratingCount+)'
        : _rating > 0
            ? _rating.toStringAsFixed(1)
            : '';
    final about = _about.isNotEmpty
        ? _about
        : 'Schedule a visit with this orthodontist through the app.';

    return Container(
      constraints: BoxConstraints(maxHeight: 0.62.sh),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: _loading
          ? SizedBox(
              height: 220.h,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 100.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColor.whiteColor,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _buildHero(),
                  ),
                ),
                SizedBox(height: 14.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _name,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                    if (ratingLabel.isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: const Color(0xffF5A623),
                            size: 18.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            ratingLabel,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 10.h),
                Text(
                  about,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 13.sp,
                    height: 1.45,
                    color: AppColor.whiteColor.withValues(alpha: 0.88),
                  ),
                ),
                SizedBox(height: 18.h),
                Material(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(9999),
                  child: InkWell(
                    onTap: () => widget.onSchedule(widget.orthodontistId, _name),
                    borderRadius: BorderRadius.circular(9999),
                    child: SizedBox(
                      height: 52.h,
                      child: Center(
                        child: Text(
                          'Schedule Appointment',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColor.textDark,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
