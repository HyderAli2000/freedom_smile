import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/about_app_screen.dart';
import 'package:freedom_smile/agreements.dart';
import 'package:freedom_smile/change_password_screen.dart';
import 'package:freedom_smile/delete_account_screen.dart';
import 'package:freedom_smile/faqs_screen.dart';
import 'package:freedom_smile/profile_view_screen.dart';
import 'package:freedom_smile/appointments_screen.dart';
import 'package:freedom_smile/chat_list_screen.dart';
import 'package:freedom_smile/set_reminder_home.dart';
import 'package:freedom_smile/chat_support_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/controllers/locale_controller.dart';
import 'package:freedom_smile/widgets/settings/language_selection_dialog.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _languages = [
    LanguageOption(code: 'en', labelKey: 'language_english', flagEmoji: '🇺🇸'),
    LanguageOption(code: 'es', labelKey: 'language_spanish', flagEmoji: '🇪🇸'),
  ];

  Future<void> _openLanguageDialog(BuildContext context) async {
    final localeController = Get.find<LocaleController>();
    final result = await LanguageSelectionDialog.show(
      context,
      initialCode: localeController.locale.languageCode,
      languages: _languages,
    );
    if (result != null) {
      await localeController.setLocaleCode(result);
    }
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
                const _ProfileCard(),
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
                  subtitle: 'settings_scheduled_appointments_subtitle'.tr,
                  onTap: () => Get.to(() => const AppointmentsScreen()),
                ),
                20.verticalSpace,
                _SectionLabel('section_reminder'.tr),
                10.verticalSpace,
                _SettingsActionTile(
                  iconAsset: AssetIcons.night,
                  title: 'settings_your_reminder_title'.tr,
                  subtitle: 'settings_your_reminder_subtitle'.tr,
                  onTap: () => Get.to(() => const SetReminderHome()),
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Get.to(() => const ProfileViewScreen()),
        borderRadius: BorderRadius.circular(18.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.primaryBlue,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundImage: AssetImage(AssetImages.p1),
              ),
              14.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anderson Smith',
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
                      '@anderson.smith',
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
