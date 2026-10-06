import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/appointment_detail_screen.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/appointments_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class AppointmentsScreen extends StatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  State<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _service = UserService();
  bool _showCompleted = false;
  bool _loading = true;
  List<AppointmentItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    setState(() => _loading = true);
    try {
      final status = _showCompleted ? 'completed' : 'pending';
      final result = await _service.listAppointments(status: status);
      final rows = ApiMap.mapList(result.data, 'appointments');
      _items = rows.map(_mapAppointment).toList();
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  AppointmentItem _mapAppointment(Map<String, dynamic> map) {
    final ortho = ApiMap.map(map['orthodontist']);
    final id = ApiMap.id(map);
    final shortId = id.length > 5 ? '#${id.substring(id.length - 5)}' : '#$id';
    final ratingCount = ApiMap.intVal(ortho['ratingCount']);
    final status = ApiMap.str(map['status']).toLowerCase();
    return AppointmentItem(
      id: shortId,
      apiId: id,
      title: ApiMap.str(ortho['name'], 'Orthodontist'),
      time: ApiMap.str(map['timeSlot']),
      date: ApiMap.formatDate(map['date']),
      rating: ApiMap.doubleVal(ortho['rating']),
      reviewCount: ratingCount > 0 ? '$ratingCount' : '0',
      imageAsset: ApiMap.imageOrFallback(ortho['profilePicture']),
      isCompleted: status == 'completed',
    );
  }

  Future<void> _openDetail(AppointmentItem item) async {
    if (item.apiId.isEmpty) return;
    final changed = await Get.to<bool>(
      () => AppointmentDetailScreen(appointmentId: item.apiId),
    );
    if (changed == true && mounted) await _loadAppointments();
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
                    _loadAppointments();
                  },
                ),
                20.verticalSpace,
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isEmpty
                          ? Center(
                              child: Text(
                                'No appointments',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
                                  fontSize: 14.sp,
                                  color: AppColor.textBody,
                                ),
                              ),
                            )
                          : ListView.separated(
                              padding: EdgeInsets.only(bottom: 20.h),
                              itemCount: _items.length,
                              separatorBuilder: (_, __) => 14.verticalSpace,
                              itemBuilder: (context, index) {
                                final item = _items[index];
                                return _AppointmentCard(
                                  item: item,
                                  onTap: () => _openDetail(item),
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
  const _AppointmentCard({required this.item, required this.onTap});

  final AppointmentItem item;
  final VoidCallback onTap;

  Widget _buildImage() {
    final src = item.imageAsset;
    if (ApiMap.isNetworkImage(src)) {
      return Image.network(
        ApiMap.resolveMediaUrl(src)!,
        width: 72.w,
        height: 72.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetImages.pc1,
          width: 72.w,
          height: 72.w,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      src,
      width: 72.w,
      height: 72.w,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
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
                child: _buildImage(),
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
                          item.date.isEmpty
                              ? ''
                              : '${item.date.split(',').first},',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.textBody,
                          ),
                        ),
                        10.horizontalSpace,
                        Container(
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
        ),
      ),
    );
  }
}
