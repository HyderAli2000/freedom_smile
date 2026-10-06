import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/retainer_fit_screen.dart';
import 'package:freedom_smile/widgets/profile/profile_onboarding_widgets.dart';
import 'package:get/get.dart';

class RetainerTypeScreen extends StatefulWidget {
  const RetainerTypeScreen({super.key});

  @override
  State<RetainerTypeScreen> createState() => _RetainerTypeScreenState();
}

class _RetainerTypeScreenState extends State<RetainerTypeScreen> {
  static const _types = [
    'Clear (Removable)',
    'Hawley',
    'Fixed',
    'Essix',
    'Other',
  ];

  late DateTime _selectedDate;
  String? _selectedType;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _changeYear(int delta) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year + delta,
        _selectedDate.month,
        _selectedDate.day,
      );
    });
  }

  void _changeMonth(int delta) {
    setState(() {
      _selectedDate = DateTime(
        _selectedDate.year,
        _selectedDate.month + delta,
        _selectedDate.day,
      );
    });
  }

  String get _receivedDateIso {
    final y = _selectedDate.year.toString().padLeft(4, '0');
    final m = _selectedDate.month.toString().padLeft(2, '0');
    final d = _selectedDate.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _onNext() async {
    if (_saving) return;
    if (_selectedType == null) {
      ApiSnackbar.error('Please select your retainer type');
      return;
    }

    setState(() => _saving = true);
    try {
      // Postman: PUT /user/retainer
      await UserService().updateRetainer({
        'type': _selectedType,
        'receivedDate': _receivedDateIso,
      });
      // Keep onboarding step in sync (create-profile step 2)
      await AuthService().createProfile({
        'step': 2,
        'retainerType': _selectedType,
        'receivedDate': _receivedDateIso,
      });
      Get.to(() => const RetainerFitScreen());
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (e) {
      ApiSnackbar.error(e.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileOnboardingScaffold(
      title: 'Tell About Your Retainer',
      stepText: 'Step 2/5',
      onNext: _saving ? () {} : _onNext,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileQuestionTitle(text: 'What type of retainer do you use?'),
          14.verticalSpace,
          ..._types.map(
            (type) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: ProfileOptionButton(
                label: type,
                isSelected: _selectedType == type,
                onTap: () => setState(() => _selectedType = type),
              ),
            ),
          ),
          20.verticalSpace,
          const ProfileQuestionTitle(
            text: 'When did you get your current retainer?',
          ),
          14.verticalSpace,
          ProfileYearSelector(
            year: _selectedDate.year,
            onPrevious: () => _changeYear(-1),
            onNext: () => _changeYear(1),
          ),
          14.verticalSpace,
          ProfileCalendarPicker(
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = date),
            onPreviousMonth: () => _changeMonth(-1),
            onNextMonth: () => _changeMonth(1),
          ),
          if (_saving) ...[
            20.verticalSpace,
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}
