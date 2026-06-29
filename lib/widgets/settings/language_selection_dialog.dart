import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';

class LanguageOption {
  const LanguageOption({required this.name, required this.flagEmoji});

  final String name;
  final String flagEmoji;
}

class LanguageSelectionDialog extends StatefulWidget {
  const LanguageSelectionDialog({
    super.key,
    required this.initialLanguage,
    required this.languages,
  });

  final String initialLanguage;
  final List<LanguageOption> languages;

  static Future<String?> show(
    BuildContext context, {
    required String initialLanguage,
    required List<LanguageOption> languages,
  }) {
    return showGeneralDialog<String?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Language',
      barrierColor: Colors.black.withValues(alpha: 0.45),
      transitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return LanguageSelectionDialog(
          initialLanguage: initialLanguage,
          languages: languages,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 4 * animation.value,
            sigmaY: 4 * animation.value,
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  State<LanguageSelectionDialog> createState() =>
      _LanguageSelectionDialogState();
}

class _LanguageSelectionDialogState extends State<LanguageSelectionDialog> {
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.languages.any(
      (language) => language.name == widget.initialLanguage,
    )
        ? widget.initialLanguage
        : widget.languages.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 28.w),
          padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 24.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xffFFFFFF),
                Color.fromARGB(255, 221, 243, 255),
                Color.fromARGB(255, 190, 232, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Language',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textDark,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.close_rounded,
                      size: 22.sp,
                      color: AppColor.textDark.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
              14.verticalSpace,
              Divider(
                height: 1,
                color: AppColor.borderLightBlue.withValues(alpha: 0.6),
              ),
              16.verticalSpace,
              Text(
                'Select your preferred language',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textBody,
                ),
              ),
              16.verticalSpace,
              ...widget.languages.map((language) {
                final isSelected = _selectedLanguage == language.name;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _LanguageTile(
                    language: language,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() => _selectedLanguage = language.name);
                    },
                  ),
                );
              }),
              8.verticalSpace,
              SizedBox(
                height: 50.h,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(_selectedLanguage),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryBlue,
                    foregroundColor: AppColor.whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999.r),
                    ),
                  ),
                  icon: Icon(Icons.save_outlined, size: 20.sp),
                  label: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.language,
    required this.isSelected,
    required this.onTap,
  });

  final LanguageOption language;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.whiteColor,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.whiteColor,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected ? AppColor.textDark : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Text(
                language.flagEmoji,
                style: TextStyle(fontSize: 22.sp),
              ),
              12.horizontalSpace,
              Expanded(
                child: Text(
                  language.name,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textDark,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: const BoxDecoration(
                    color: AppColor.textDark,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColor.whiteColor,
                    size: 16.sp,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
