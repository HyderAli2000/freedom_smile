import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/app_network_image.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentDetailScreen> createState() =>
      _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  final _service = UserService();
  bool _loading = true;
  bool _cancelling = false;
  bool _changed = false;
  Map<String, dynamic> _appointment = const {};
  Map<String, dynamic> _ortho = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Postman: GET /user/appointments/:id
      final result = await _service.getAppointment(widget.appointmentId);
      final data = ApiMap.map(result.data);
      final appointment = ApiMap.map(data['appointment'] ?? data);
      if (!mounted) return;
      setState(() {
        _appointment = appointment;
        _ortho = ApiMap.map(appointment['orthodontist']);
        _loading = false;
      });
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _loading = false);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _cancel() async {
    if (_cancelling) return;
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (dialogContext) => _CancelAppointmentDialog(
        onClose: () => Navigator.of(dialogContext).pop(false),
        onKeep: () => Navigator.of(dialogContext).pop(false),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed != true) return;

    setState(() => _cancelling = true);
    try {
      final result = await _service.cancelAppointment(widget.appointmentId);
      ApiSnackbar.success(result.message);
      final data = ApiMap.map(result.data);
      final updated = ApiMap.map(data['appointment'] ?? data);
      if (!mounted) return;
      setState(() {
        _changed = true;
        if (updated.isNotEmpty) {
          _appointment = {
            ..._appointment,
            ...updated,
            'status': ApiMap.str(updated['status'], 'cancelled'),
          };
          final ortho = ApiMap.map(updated['orthodontist']);
          if (ortho.isNotEmpty) _ortho = ortho;
        } else {
          _appointment = {..._appointment, 'status': 'cancelled'};
        }
        _cancelling = false;
      });
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      if (mounted) setState(() => _cancelling = false);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
      if (mounted) setState(() => _cancelling = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = ApiMap.str(_appointment['status']).toLowerCase();
    // Only pending appointments can be cancelled.
    final canCancel = status == 'pending';
    final name = ApiMap.str(_ortho['name'], 'Orthodontist');
    final about = ApiMap.str(_ortho['about']);
    final address = [
      ApiMap.str(_ortho['address']),
      ApiMap.str(_ortho['city']),
    ].where((e) => e.isNotEmpty).join(', ');
    final phone = ApiMap.str(_ortho['phone']);
    final image = ApiMap.imageOrFallback(_ortho['profilePicture']);
    final date = ApiMap.formatDate(_appointment['date']);
    final time = ApiMap.str(_appointment['timeSlot']);
    final source = ApiMap.str(_appointment['source'], 'general');
    final notes = ApiMap.str(_appointment['notes']);
    final rating = ApiMap.doubleVal(_ortho['rating']);
    final ratingCount = ApiMap.intVal(_ortho['ratingCount']);

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                child: PageHeader(
                  title: 'Appointment Detail',
                  onBack: () => Get.back(result: _changed),
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: AppColor.whiteColor.withValues(alpha: 0.92),
                            borderRadius: BorderRadius.circular(18.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14.r),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: AppNetworkImage(
                                    source: image,
                                    fallbackAsset: AssetImages.pc1,
                                  ),
                                ),
                              ),
                              14.verticalSpace,
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.textDark,
                                ),
                              ),
                              if (rating > 0) ...[
                                6.verticalSpace,
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: const Color(0xFFFFB800),
                                      size: 18.sp,
                                    ),
                                    4.horizontalSpace,
                                    Text(
                                      ratingCount > 0
                                          ? '${rating.toStringAsFixed(1)} ($ratingCount)'
                                          : rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontFamilyFallback: AppFonts.fallback,
                                        fontSize: 13.sp,
                                        color: AppColor.textBody,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              14.verticalSpace,
                              _InfoRow(label: 'Date', value: date),
                              _InfoRow(label: 'Time', value: time),
                              _InfoRow(
                                label: 'Status',
                                value: status.isEmpty ? '-' : status,
                              ),
                              _InfoRow(label: 'Source', value: source),
                              if (address.isNotEmpty)
                                _InfoRow(label: 'Address', value: address),
                              if (phone.isNotEmpty)
                                _InfoRow(label: 'Phone', value: phone),
                              if (notes.isNotEmpty)
                                _InfoRow(label: 'Notes', value: notes),
                              if (about.isNotEmpty) ...[
                                10.verticalSpace,
                                Text(
                                  about,
                                  style: TextStyle(
                                    fontFamily: AppFonts.family,
                                    fontFamilyFallback: AppFonts.fallback,
                                    fontSize: 13.sp,
                                    height: 1.4,
                                    color: AppColor.textBody,
                                  ),
                                ),
                              ],
                              if (canCancel) ...[
                                24.verticalSpace,
                                SizedBox(
                                  height: 50.h,
                                  child: OutlinedButton(
                                    onPressed: _cancelling ? null : _cancel,
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: const Color(0xffE8453C),
                                      side: const BorderSide(
                                        color: Color(0xffE8453C),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                    ),
                                    child: Text(
                                      _cancelling
                                          ? '...'
                                          : 'Cancel appointment',
                                      style: TextStyle(
                                        fontFamily: AppFonts.family,
                                        fontFamilyFallback: AppFonts.fallback,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72.w,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.textDark,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 13.sp,
                color: AppColor.textBody,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Matches the book-appointment confirmation dialog theme.
class _CancelAppointmentDialog extends StatelessWidget {
  const _CancelAppointmentDialog({
    required this.onClose,
    required this.onKeep,
    required this.onConfirm,
  });

  final VoidCallback onClose;
  final VoidCallback onKeep;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          gradient: const LinearGradient(
            colors: [
              Color(0xffFFFFFF),
              Color.fromARGB(255, 221, 243, 255),
              Color.fromARGB(255, 190, 232, 255),
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Cancel Appointment',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.blackColor,
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onClose,
                      customBorder: const CircleBorder(),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppColor.blackColor.withValues(alpha: 0.55),
                        size: 22.sp,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Center(
              child: Container(
                width: 72.r,
                height: 72.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffE8453C),
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: const Color(0xffE8453C),
                  size: 36.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Are you sure you want to cancel this appointment?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: AppColor.blackColor.withValues(alpha: 0.65),
              ),
            ),
            SizedBox(height: 24.h),
            Material(
              color: AppColor.primaryBlue,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                onTap: onKeep,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 48.h,
                  child: Center(
                    child: Text(
                      'Keep Appointment',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(9999),
              child: InkWell(
                onTap: onConfirm,
                borderRadius: BorderRadius.circular(9999),
                child: Container(
                  height: 48.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(color: const Color(0xffE8453C)),
                  ),
                  child: Text(
                    'Yes, Cancel',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xffE8453C),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
