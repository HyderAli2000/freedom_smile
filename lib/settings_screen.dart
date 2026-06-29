import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import 'package:freedom_smile/widgets/settings/language_selection_dialog.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'English';

  static const _languages = [
    LanguageOption(name: 'English', flagEmoji: '🇺🇸'),
    LanguageOption(name: 'Spanish', flagEmoji: '🇪🇸'),
  ];

  Future<void> _openLanguageDialog() async {
    final result = await LanguageSelectionDialog.show(
      context,
      initialLanguage: _selectedLanguage,
      languages: _languages,
    );
    if (result != null && mounted) {
      setState(() => _selectedLanguage = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ProfileCard(),
            24.verticalSpace,
            const _SectionLabel('Appointment'),
            10.verticalSpace,
            _SettingsActionTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chat',
              subtitle: 'Start chat with your orthodontist',
              onTap: () => Get.to(() => const ChatListScreen()),
            ),
            20.verticalSpace,
            const _SectionLabel('Appointment'),
            10.verticalSpace,
            _SettingsActionTile(
              iconAsset: AssetIcons.teeth1,
              title: 'Scheduled Appointments',
              subtitle: 'Get Detailed of your appointments',
              onTap: () => Get.to(() => const AppointmentsScreen()),
            ),
            20.verticalSpace,
            const _SectionLabel('Reminder'),
            10.verticalSpace,
            _SettingsActionTile(
              iconAsset: AssetIcons.night,
              title: 'Your Reminder',
              subtitle: '10:00 PM (Night)',
              onTap: () => Get.to(() => const SetReminderHome()),
            ),
            20.verticalSpace,
            const _SectionLabel('Language Preference'),
            10.verticalSpace,
            _LanguagePreferenceCard(
              selectedLanguage: _selectedLanguage,
              onTap: _openLanguageDialog,
            ),
            20.verticalSpace,
            const _SectionLabel('FAQ'),
            10.verticalSpace,
            _SettingsActionTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Frequently Asked Questions',
              subtitle: 'Get answers to your questions',
              onTap: () => Get.to(() => const FaqsScreen()),
            ),

            20.verticalSpace,
            const _SectionLabel('Chat Support'),
            10.verticalSpace,
            _SettingsActionTile(
              icon: Icons.chat_bubble_outline_rounded,
              title: 'Chat Support',
              subtitle: 'Get help from our support team',
              onTap: () => Get.to(() => const ChatSupportScreen()),
            ),

            20.verticalSpace,
            const _SectionLabel('Change Password'),
            10.verticalSpace,
            _SettingsActionTile(
              icon: Icons.lock_rounded,
              title: 'Change Password',
              subtitle: 'Change your password',
              onTap: () => Get.to(() => const ChangePasswordScreen()),
            ),
            20.verticalSpace,
            const _SectionLabel('Delete Account'),
            10.verticalSpace,
            _SettingsActionTile(
              icon: Icons.delete_rounded,
              title: 'Delete Account',
              subtitle: 'Delete your account',
              onTap: () => Get.to(() => const DeleteAccountScreen()),
            ),
          ],
        ),
      ),
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
                      'Language',
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
                      'Select your preferred language',
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
