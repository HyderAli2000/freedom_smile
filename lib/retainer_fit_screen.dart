import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/data/services/user_service.dart';
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

  String? _fit;
  String? _wearsDaily;
  bool _saving = false;

  Future<void> _onNext() async {
    if (_saving) return;
    if (_fit == null || _wearsDaily == null) {
      ApiSnackbar.error('Please answer both questions');
      return;
    }

    setState(() => _saving = true);
    try {
      // Postman: PUT /user/retainer
      await UserService().updateRetainer({
        'fit': _fit,
        'wearsDaily': _wearsDaily,
      });
      // Keep onboarding step in sync (create-profile step 3)
      await AuthService().createProfile({
        'step': 3,
        'fit': _fit,
        'wearsDaily': _wearsDaily,
      });
      Get.to(() => const SetReminderScreen());
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
      stepText: 'Step 3/5',
      onNext: _saving ? () {} : _onNext,
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
                isSelected: _fit == option,
                onTap: () => setState(() => _fit = option),
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
                isSelected: _wearsDaily == option,
                onTap: () => setState(() => _wearsDaily = option),
              ),
            ),
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
