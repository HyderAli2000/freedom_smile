import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/about_app_screen.dart';
import 'package:freedom_smile/agreements.dart';
import 'package:freedom_smile/change_password_screen.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/delete_account_screen.dart';
import 'package:freedom_smile/faqs_screen.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:freedom_smile/profile_view_screen.dart';
import 'package:freedom_smile/appointments_screen.dart';
import 'package:freedom_smile/chat_list_screen.dart';
import 'package:freedom_smile/set_reminder_home.dart';
import 'package:freedom_smile/chat_support_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/controllers/locale_controller.dart';
import 'package:freedom_smile/data/services/auth_service.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/widgets/common/app_network_image.dart';
import 'package:freedom_smile/widgets/settings/language_selection_dialog.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _languages = [
    LanguageOption(code: 'en', labelKey: 'language_english', flagEmoji: '🇺🇸'),
    LanguageOption(code: 'es', labelKey: 'language_spanish', flagEmoji: '🇪🇸'),
  ];

  final _profileKey = GlobalKey<_ProfileCardState>();
  String _reminderSubtitle = 'settings_your_reminder_subtitle'.tr;
  String _appointmentsSubtitle = 'settings_scheduled_appointments_subtitle'.tr;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  String _formatReminder(Map<String, dynamic> reminder) {
    final time = ApiMap.str(reminder['time'], '10:00');
    final period = ApiMap.str(reminder['period'], 'PM').toUpperCase();
    final type = ApiMap.str(reminder['type'], 'night').toLowerCase();
    final typeLabel = switch (type) {
      'morning' => 'Morning',
      'custom' || 'customtime' || 'custom_time' => 'Custom',
      _ => 'Night',
    };
    return '$time $period ($typeLabel)';
  }

  Future<void> _persistUser(Map<String, dynamic> user) async {
    final email = ApiMap.str(user['email']);
    if (email.isNotEmpty) await AppStorage.setEmail(email);
    final id = ApiMap.str(user['_id'] ?? user['id']);
    if (id.isNotEmpty) await AppStorage.setUserId(id);
    final role = ApiMap.str(user['userType']);
    if (role.isNotEmpty) await AppStorage.setRole(role);
    if (user.containsKey('firstName')) {
      await AppStorage.setFirstName(ApiMap.str(user['firstName']));
    }
    if (user.containsKey('lastName')) {
      await AppStorage.setLastName(ApiMap.str(user['lastName']));
    }
    if (user.containsKey('fullName')) {
      await AppStorage.setFullName(ApiMap.str(user['fullName']));
    }
    if (user.containsKey('username')) {
      await AppStorage.setUsername(ApiMap.str(user['username']));
    }
    if (user.containsKey('profilePicture')) {
      final pic = ApiMap.str(user['profilePicture']);
      await AppStorage.setProfilePicture(pic.isEmpty ? null : pic);
    }
    if (user['isProfileCompleted'] is bool) {
      await AppStorage.setProfileComplete(user['isProfileCompleted'] as bool);
    }
  }

  Future<void> _loadSettings() async {
    try {
      // Postman: GET /user/settings
      final result = await UserService().settings();
      final data = ApiMap.map(result.data);
      final user = ApiMap.map(data['user']);
      final reminder = ApiMap.map(data['reminder']);
      final pending = ApiMap.intVal(data['pendingAppointments']);

      if (user.isNotEmpty) await _persistUser(user);

      if (!mounted) return;
      setState(() {
        if (reminder.isNotEmpty) {
          _reminderSubtitle = _formatReminder(reminder);
        }
        if (pending > 0) {
          _appointmentsSubtitle = pending == 1
              ? '1 pending appointment'
              : '$pending pending appointments';
        } else {
          _appointmentsSubtitle = 'settings_scheduled_appointments_subtitle'.tr;
        }
      });
      _profileKey.currentState?.refresh();
    } catch (_) {
      // Keep static subtitles / cached profile if settings fails.
    }
  }

  Future<void> _openLanguageDialog(BuildContext context) async {
    final localeController = Get.find<LocaleController>();
    final result = await LanguageSelectionDialog.show(
      context,
      initialCode: localeController.locale.languageCode,
      languages: _languages,
    );
    if (result != null) {
      await localeController.setLocaleCode(result);
      try {
        final language = result == 'es' ? 'Spanish' : 'English';
        await AuthService().updateLanguage(language: language);
      } catch (_) {
        // Local language still applied even if API fails (offline).
      }
    }
  }

  Future<void> _openReminders() async {
    await Get.to(() => const SetReminderHome());
    if (mounted) await _loadSettings();
  }

  Future<void> _openAppointments() async {
    await Get.to(() => const AppointmentsScreen());
    if (mounted) await _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return GetBuilder<LocaleController>(
      builder: (_) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileCard(key: _profileKey),
                24.verticalSpace,
                _SectionLabel('section_chat'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'settings_chat_title'.tr,
                  subtitle: 'settings_chat_subtitle'.tr,
                  onTap: () => Get.to(() => const ChatListScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_appointment'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  iconAsset: AssetIcons.teeth1,
                  title: 'settings_scheduled_appointments_title'.tr,
                  subtitle: _appointmentsSubtitle,
                  onTap: _openAppointments,
                ),
                20.verticalSpace,
                _SectionLabel('section_reminder'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  iconAsset: AssetIcons.night,
                  title: 'settings_your_reminder_title'.tr,
                  subtitle: _reminderSubtitle,
                  onTap: _openReminders,
                ),
                20.verticalSpace,
                _SectionLabel('section_language_preference'.tr),
                10.verticalSpace,
                _LanguagePreferenceCard(
                  selectedLanguage: localeController.currentLanguageLabel,
                  onTap: () => _openLanguageDialog(context),
                ),
                20.verticalSpace,
                _SectionLabel('section_faq'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'settings_faq_title'.tr,
                  subtitle: 'settings_faq_subtitle'.tr,
                  onTap: () => Get.to(() => const FaqsScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_chat_support'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.chat_bubble_outline_rounded,
                  title: 'chat_support'.tr,
                  subtitle: 'settings_chat_support_subtitle'.tr,
                  onTap: () => Get.to(() => const ChatSupportScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_change_password'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.lock_rounded,
                  title: 'change_password'.tr,
                  subtitle: 'settings_change_password_subtitle'.tr,
                  onTap: () => Get.to(() => const ChangePasswordScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_delete_account'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.delete_rounded,
                  title: 'delete_account'.tr,
                  subtitle: 'settings_delete_account_subtitle'.tr,
                  onTap: () => Get.to(() => const DeleteAccountScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_agreements'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.description_rounded,
                  title: 'agreements'.tr,
                  subtitle: 'settings_agreements_subtitle'.tr,
                  onTap: () => Get.to(() => const AgreementsScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_about_app'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  icon: Icons.app_registration_rounded,
                  title: 'about_app'.tr,
                  subtitle: 'settings_about_app_subtitle'.tr,
                  onTap: () => Get.to(() => const AboutAppScreen()),
                ),
                28.verticalSpace,
                _LogoutButton(onTap: () => _logout(context)),
                12.verticalSpace,
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      builder: (dialogContext) => _LogoutConfirmDialog(
        onClose: () => Navigator.of(dialogContext).pop(false),
        onCancel: () => Navigator.of(dialogContext).pop(false),
        onConfirm: () => Navigator.of(dialogContext).pop(true),
      ),
    );
    if (confirmed != true) return;

    try {
      await AuthService().logout();
    } catch (_) {
      // Session already cleared in AuthService even if API fails.
    }
    Get.offAll(() => const LoginScreen());
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({super.key});

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final name = AppStorage.displayName.isEmpty
        ? 'User'
        : AppStorage.displayName;
    final handle = AppStorage.username != null && AppStorage.username!.isNotEmpty
        ? '@${AppStorage.username}'
        : (AppStorage.email ?? '');
    final picture = AppStorage.profilePicture;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          await Get.to(() => const ProfileViewScreen());
          if (mounted) setState(() {});
        },
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.primaryBlue,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              AppCircleAvatar(
                radius: 28.r,
                source: picture,
                backgroundColor: AppColor.whiteColor,
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      handle,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.whiteColor.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColor.whiteColor,
                size: 26.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontFamilyFallback: AppFonts.fallback,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.textBody,
      ),
    );
  }
}

class _SettingsActionTile extends StatelessWidget {
  const _SettingsActionTile({
    this.icon,
    this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData? icon;
  final String? iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColor.borderLightBlue.withValues(alpha: 0.4),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(10.w),
                child: iconAsset != null
                    ? Image.asset(
                        iconAsset!,
                        color: AppColor.whiteColor,
                        fit: BoxFit.contain,
                      )
                    : Icon(icon, color: AppColor.whiteColor, size: 22.sp),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textDark,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColor.textBody,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColor.primaryBlue,
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguagePreferenceCard extends StatelessWidget {
  const _LanguagePreferenceCard({
    required this.selectedLanguage,
    required this.onTap,
  });

  final String selectedLanguage;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColor.profileOptionBg.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: AppColor.primaryBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.translate_rounded,
                  color: AppColor.whiteColor,
                  size: 22.sp,
                ),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'language'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textDark,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'select_preferred_language'.tr,
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
              ),
            ],
          ),
          14.verticalSpace,
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: AppColor.primaryBlue,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedLanguage,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColor.whiteColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColor.whiteColor,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: const Color(0xffFFE8E8),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xffF5B5B5)),
          ),
          child: Row(
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: const BoxDecoration(
                  color: Color(0xffE8453C),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: AppColor.whiteColor,
                  size: 22.sp,
                ),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'logout'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xffE8453C),
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      'settings_logout_subtitle'.tr,
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
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: const Color(0xffE8453C),
                size: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Matches book-appointment / cancel confirmation dialog theme.
class _LogoutConfirmDialog extends StatelessWidget {
  const _LogoutConfirmDialog({
    required this.onClose,
    required this.onCancel,
    required this.onConfirm,
  });

  final VoidCallback onClose;
  final VoidCallback onCancel;
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
                  'logout'.tr,
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
                  Icons.logout_rounded,
                  color: const Color(0xffE8453C),
                  size: 34.sp,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'logout_confirm'.tr,
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
                onTap: onCancel,
                borderRadius: BorderRadius.circular(9999),
                child: SizedBox(
                  height: 48.h,
                  child: Center(
                    child: Text(
                      'cancel'.tr,
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
                    'logout'.tr,
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
