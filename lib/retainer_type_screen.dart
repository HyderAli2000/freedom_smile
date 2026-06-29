import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/retainer_fit_screen.dart';
import 'package:freedom_smile/widgets/profile/profile_onboarding_widgets.dart';
import 'package:get/get.dart';

class RetainerTypeScreen extends StatefulWidget {
  const RetainerTypeScreen({super.key});

  @override
  State<RetainerTypeScreen> createState() => _RetainerTypeScreenState();
}

class _RetainerTypeScreenState extends State<RetainerTypeScreen> {
  late DateTime _selectedDate;
  bool isSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(2026, 4, 25);
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

  @override
  Widget build(BuildContext context) {
    return ProfileOnboardingScaffold(
      title: 'Tell About Your Retainer',
      stepText: 'Step 2/5',
      onNext: () => Get.to(() => const RetainerFitScreen()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileQuestionTitle(text: 'What type of retainer do you use?'),
          14.verticalSpace,
          ProfileOptionButton(
            label: 'Clear (Removable)',
            isSelected: isSelected,
            onTap: () {
              setState(() {
                isSelected = !isSelected;
              });
            },
          ),
          28.verticalSpace,
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
        ],
      ),
    );
  }
}
