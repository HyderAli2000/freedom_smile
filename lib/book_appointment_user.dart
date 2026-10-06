import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/appointments_screen.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

/// Book appointment — date/time selection then confirmation dialog.
class BookAppointmentUser extends StatefulWidget {
  const BookAppointmentUser({
    super.key,
    this.orthodontistId,
    this.orthodontistName,
    this.source = 'general',
    this.notes = '',
  });

  final String? orthodontistId;
  final String? orthodontistName;
  /// Backend allows only `general` | `reevaluation`.
  final String source;
  final String notes;

  @override
  State<BookAppointmentUser> createState() => _BookAppointmentUserState();
}

class _BookAppointmentUserState extends State<BookAppointmentUser> {
  final _service = UserService();

  late DateTime _month;
  late int _selectedDay;
  int _selectedTimeIndex = -1;
  bool _loadingSlots = false;
  bool _booking = false;
  List<_SlotOption> _timeSlots = const [];

  String? get _orthodontistId {
    final fromWidget = widget.orthodontistId?.trim();
    if (fromWidget != null && fromWidget.isNotEmpty) return fromWidget;
    final args = Get.arguments;
    if (args is Map) {
      final id = ApiMap.str(args['orthodontistId'] ?? args['id']);
      if (id.isNotEmpty) return id;
    }
    if (args is String && args.trim().isNotEmpty) return args.trim();
    return null;
  }

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selectedDay = now.day;
    _loadSlots();
  }

  String _dateParam(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  DateTime get _selectedDate =>
      DateTime(_month.year, _month.month, _selectedDay);

  String get _monthLabel {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${months[_month.month - 1]} ${_month.year}';
  }

  int get _daysInMonth =>
      DateTime(_month.year, _month.month + 1, 0).day;

  /// Sunday = 0
  int get _firstWeekdayOffset =>
      DateTime(_month.year, _month.month, 1).weekday % 7;

  Future<void> _loadSlots() async {
    final id = _orthodontistId;
    if (id == null) {
      setState(() {
        _timeSlots = const [];
        _selectedTimeIndex = -1;
      });
      return;
    }
    setState(() {
      _loadingSlots = true;
      _selectedTimeIndex = -1;
    });
    try {
      final result = await _service.orthodontistSlots(
        id,
        date: _dateParam(_selectedDate),
      );
      final rows = ApiMap.mapList(result.data, 'slots');
      _timeSlots = rows
          .map(
            (m) => _SlotOption(
              time: ApiMap.str(m['time']),
              available: ApiMap.boolVal(m['available'], true),
            ),
          )
          .where((s) => s.time.isNotEmpty)
          .toList();
      final firstAvailable = _timeSlots.indexWhere((s) => s.available);
      _selectedTimeIndex = firstAvailable;
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
      _timeSlots = const [];
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
      _timeSlots = const [];
    } finally {
      if (mounted) setState(() => _loadingSlots = false);
    }
  }

  Future<void> _confirmAppointment() async {
    final id = _orthodontistId;
    if (id == null) {
      ApiSnackbar.error('Please select an orthodontist first');
      return;
    }
    if (_selectedTimeIndex < 0 || _selectedTimeIndex >= _timeSlots.length) {
      ApiSnackbar.error('Please select a time slot');
      return;
    }
    final slot = _timeSlots[_selectedTimeIndex];
    if (!slot.available) {
      ApiSnackbar.error('That time slot is not available');
      return;
    }
    if (_booking) return;
    setState(() => _booking = true);
    try {
      final source = widget.source == 'reevaluation' ? 'reevaluation' : 'general';
      final result = await _service.bookAppointment({
        'orthodontistId': id,
        'date': _dateParam(_selectedDate),
        'timeSlot': slot.time,
        'source': source,
        if (widget.notes.trim().isNotEmpty) 'notes': widget.notes.trim(),
      });
      ApiSnackbar.success(result.message);
      if (!mounted) return;
      await showAppointmentConfirmedDialog(context);
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _booking = false);
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _month = DateTime(_month.year, _month.month + delta);
      final maxDay = _daysInMonth;
      if (_selectedDay > maxDay) _selectedDay = maxDay;
    });
    _loadSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetImages.bgOthers),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const PageHeader(title: 'Book Appointment'),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if ((widget.orthodontistName ?? '').isNotEmpty) ...[
                          Text(
                            widget.orthodontistName!,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColor.textBody,
                            ),
                          ),
                          SizedBox(height: 12.h),
                        ],
                        Text(
                          'Select Date',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textDark,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _CalendarCard(
                          monthLabel: _monthLabel,
                          daysInMonth: _daysInMonth,
                          firstWeekdayOffset: _firstWeekdayOffset,
                          selectedDay: _selectedDay,
                          onPrevMonth: () => _changeMonth(-1),
                          onNextMonth: () => _changeMonth(1),
                          onDaySelected: (day) {
                            setState(() => _selectedDay = day);
                            _loadSlots();
                          },
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Select Time Slot',
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColor.textDark,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (_loadingSlots)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_timeSlots.isEmpty)
                          Text(
                            'No slots available for this date',
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 13.sp,
                              color: AppColor.textBody,
                            ),
                          )
                        else
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 10.h,
                            children: List.generate(_timeSlots.length, (index) {
                              final slot = _timeSlots[index];
                              return SizedBox(
                                width: (1.sw - 40.w - 20.w) / 3,
                                child: Opacity(
                                  opacity: slot.available ? 1 : 0.45,
                                  child: _TimeSlotChip(
                                    label: slot.time,
                                    selected: _selectedTimeIndex == index,
                                    onTap: slot.available
                                        ? () => setState(
                                              () => _selectedTimeIndex = index,
                                            )
                                        : () {},
                                  ),
                                ),
                              );
                            }),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12.h, bottom: 28.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: _booking ? null : _confirmAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        _booking ? '...' : 'Confirm Appointment',
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
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
        ),
      ),
    );
  }
}

class _SlotOption {
  const _SlotOption({required this.time, required this.available});

  final String time;
  final bool available;
}

class _CalendarCard extends StatelessWidget {
  const _CalendarCard({
    required this.monthLabel,
    required this.daysInMonth,
    required this.firstWeekdayOffset,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onPrevMonth,
    required this.onNextMonth,
  });

  final String monthLabel;
  final int daysInMonth;
  final int firstWeekdayOffset;
  final int selectedDay;
  final ValueChanged<int> onDaySelected;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[];
    for (var i = 0; i < firstWeekdayOffset; i++) {
      cells.add(const SizedBox.shrink());
    }
    for (var day = 1; day <= daysInMonth; day++) {
      cells.add(
        _CalendarDayCell(
          day: day,
          selected: day == selectedDay,
          onTap: () => onDaySelected(day),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 18.h),
      decoration: BoxDecoration(
        color: AppColor.calendarBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onPrevMonth,
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColor.whiteColor,
                  size: 24.sp,
                ),
              ),
              Expanded(
                child: Text(
                  monthLabel,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onNextMonth,
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: AppColor.whiteColor,
                  size: 24.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: _weekdays
                .map(
                  (label) => Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 10.h),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 4.w,
            children: cells,
          ),
        ],
      ),
    );
  }
}

class _CalendarDayCell extends StatelessWidget {
  const _CalendarDayCell({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final int day;
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
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? AppColor.primaryBlue : Colors.transparent,
          ),
          child: Text(
            '$day',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColor.whiteColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeSlotChip extends StatelessWidget {
  const _TimeSlotChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColor.primaryBlue : AppColor.profileOptionBg,
            borderRadius: BorderRadius.circular(999999999.r),
            border: Border.all(
              color: selected
                  ? AppColor.primaryBlue
                  : AppColor.borderLightBlue.withValues(alpha: 0.45),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: selected ? AppColor.whiteColor : AppColor.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showAppointmentConfirmedDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (dialogContext) => _AppointmentConfirmedDialog(
      onClose: () => Navigator.of(dialogContext).pop(),
      onContinue: () {
        Navigator.of(dialogContext).pop();
        Get.off(() => const AppointmentsScreen());
      },
    ),
  );
}

class _AppointmentConfirmedDialog extends StatelessWidget {
  const _AppointmentConfirmedDialog({
    required this.onClose,
    required this.onContinue,
  });

  final VoidCallback onClose;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 24.h),
        decoration: BoxDecoration(
          color: AppColor.whiteColor,
          gradient: LinearGradient(
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
                  'Appointment Confirmed',
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
                  border: Border.all(color: AppColor.primaryBlue, width: 2),
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColor.primaryBlue,
                  size: 36.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              "You're all set! You'll receive timely reminders before your visit.",
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
                onTap: onContinue,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 48.h,
                  child: Center(
                    child: Text(
                      'Continue',
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
          ],
        ),
      ),
    );
  }
}
