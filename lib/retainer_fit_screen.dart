import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/set_reminder_screen.dart';
import 'package:freedom_smile/widgets/profile/profile_onboarding_widgets.dart';
import 'package:get/get.dart';

class RetainerFitScreen extends StatefulWidget {
  const RetainerFitScreen({super.key});

  @override
  State<RetainerFitScreen> createState() => _RetainerFitScreenState();
}

class _RetainerFitScreenState extends State<RetainerFitScreen> {
  static const _fitOptions = [
    'Fits perfectly',
    'Slightly uncomfortable',
    "Doesn't fit",
  ];

  static const _wearOptions = ['Yes', 'Sometimes', 'Not really'];

  final List<String> _selectedOptions = [];

  void _toggleOption(String option) {
    setState(() {
      if (_selectedOptions.contains(option)) {
        _selectedOptions.remove(option);
      } else {
        _selectedOptions.add(option);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProfileOnboardingScaffold(
      title: 'Tell About Your Retainer',
      stepText: 'Step 3/5',
      onNext: () => Get.to(() => const SetReminderScreen()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const ProfileQuestionTitle(text: 'Does it fit properly?'),
          14.verticalSpace,
          ..._fitOptions.map(
            (option) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ProfileOptionButton(
                label: option,
                isSelected: _selectedOptions.contains(option),
                onTap: () => _toggleOption(option),
              ),
            ),
          ),
          20.verticalSpace,
          const ProfileQuestionTitle(text: 'Do you wear your retainer daily?'),
          14.verticalSpace,
          ..._wearOptions.map(
            (option) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: ProfileOptionButton(
                label: option,
                isSelected: _selectedOptions.contains(option),
                onTap: () => _toggleOption(option),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
