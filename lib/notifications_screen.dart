import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/notifications_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _service = UserService();
  bool _loading = true;
  List<NotificationItem> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await _service.listNotifications();
      final rows = ApiMap.mapList(result.data, 'notifications');
      _items = rows.map(_mapNotification).toList();
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  NotificationItem _mapNotification(Map<String, dynamic> map) {
    final type = ApiMap.str(map['type']).toLowerCase();
    final kind = _kindFor(type);
    final showActions = type.contains('wear') ||
        type.contains('reminder') ||
        type == 'already_wear';
    return NotificationItem(
      id: ApiMap.id(map),
      kind: kind,
      title: ApiMap.str(map['title']),
      body: ApiMap.str(map['body']),
      timestamp: ApiMap.relativeTime(map['createdAt']),
      icon: _iconFor(kind),
      showActions: showActions,
      isRead: ApiMap.boolVal(map['isRead']),
    );
  }

  NotificationKind _kindFor(String type) {
    if (type.contains('reward')) return NotificationKind.reward;
    if (type.contains('referral')) return NotificationKind.referral;
    if (type.contains('habit')) return NotificationKind.habit;
    if (type.contains('feature')) return NotificationKind.feature;
    return NotificationKind.reminder;
  }

  IconData? _iconFor(NotificationKind kind) {
    switch (kind) {
      case NotificationKind.reminder:
        return Icons.access_time_rounded;
      case NotificationKind.habit:
        return Icons.bolt_rounded;
      case NotificationKind.reward:
        return Icons.star_rounded;
      case NotificationKind.referral:
        return Icons.card_giftcard_rounded;
      case NotificationKind.feature:
        return null;
    }
  }

  Future<void> _markRead(NotificationItem item) async {
    if (item.id.isEmpty || item.isRead) return;
    try {
      await _service.markNotificationRead(item.id);
      if (!mounted) return;
      setState(() {
        _items = [
          for (final n in _items)
            if (n.id == item.id) n.copyWith(isRead: true) else n,
        ];
      });
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    }
  }

  Future<void> _alreadyWear(NotificationItem item) async {
    if (item.id.isEmpty) return;
    try {
      final result =
          await _service.notificationAction(item.id, 'already_wear');
      ApiSnackbar.success(result.message);
      await _markRead(item);
      if (!mounted) return;
      setState(() {
        _items = [
          for (final n in _items)
            if (n.id == item.id)
              n.copyWith(showActions: false, isRead: true)
            else
              n,
        ];
      });
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    }
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
                  title: 'notifications'.tr,
                  whiteBackButton: true,
                ),
                20.verticalSpace,
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _items.isEmpty
                          ? Center(
                              child: Text(
                                'No notifications',
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
                                  fontSize: 14.sp,
                                  color: AppColor.textBody,
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _load,
                              child: ListView.separated(
                                padding: EdgeInsets.only(bottom: 20.h),
                                itemCount: _items.length,
                                separatorBuilder: (_, __) => 12.verticalSpace,
                                itemBuilder: (context, index) {
                                  final item = _items[index];
                                  return _NotificationCard(
                                    item: item,
                                    onTap: () => _markRead(item),
                                    onAlreadyWear: () => _alreadyWear(item),
                                  );
                                },
                              ),
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

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.onTap,
    required this.onAlreadyWear,
  });

  final NotificationItem item;
  final VoidCallback onTap;
  final VoidCallback onAlreadyWear;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: item.isRead ? 0.72 : 1,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.borderLightBlue.withValues(alpha: 0.4),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.icon != null) ...[
                    _NotificationIcon(icon: item.icon!),
                    12.horizontalSpace,
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                                style: TextStyle(
                                  fontFamily: AppFonts.family,
                                  fontFamilyFallback: AppFonts.fallback,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.textDark,
                                  height: 1.35,
                                ),
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              item.timestamp,
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
                        8.verticalSpace,
                        Text(
                          item.body,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColor.textBody,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (item.showActions) ...[
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: _NotificationOutlinedButton(
                        label: 'remind_later'.tr,
                        onTap: onTap,
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: _NotificationFilledButton(
                        label: 'already_wear'.tr,
                        onTap: onAlreadyWear,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(
        icon,
        color: AppColor.whiteColor,
        size: 22.sp,
      ),
    );
  }
}

class _NotificationOutlinedButton extends StatelessWidget {
  const _NotificationOutlinedButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColor.primaryBlue,
          side: const BorderSide(color: AppColor.primaryBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _NotificationFilledButton extends StatelessWidget {
  const _NotificationFilledButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryBlue,
          foregroundColor: AppColor.whiteColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
