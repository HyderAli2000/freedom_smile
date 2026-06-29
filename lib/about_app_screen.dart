import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  static const _appVersion = '1.0.0';

  static const _bodyText =
      'Arcu risus, lacus, et felis, vel vitae pulvinar. Nec viverra sit mattis morbi sagittis, eget dictum urna. Et viverra sed gravida id. Proin ut facilisis viverra nisi pulvinar at sed. Neque turpis tempor venenatis neque pellentesque lectus et morbi. Lacinia nunc ac, nullam malesuada dictum turpis accumsan, venenatis.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: const PageHeader(
                  title: 'About App',
                  whiteBackButton: true,
                ),
              ),
              12.verticalSpace,
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                    border: Border.all(
                      color: AppColor.primaryBlue.withValues(alpha: 0.35),
                      width: 1.2,
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _AboutSection(
                          heading: 'Lorem ipsum dolor sit amet consectetur.',
                          body: _bodyText,
                        ),
                        28.verticalSpace,
                        const _AboutSection(
                          heading: 'Lorem ipsum dolor sit amet consectetur.',
                          body: _bodyText,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const _AboutFooter(version: _appVersion),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  const _AboutSection({required this.heading, required this.body});

  final String heading;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
            height: 1.35,
          ),
        ),
        14.verticalSpace,
        Text(
          body,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.agreementText,
            height: 1.65,
          ),
        ),
      ],
    );
  }
}

class _AboutFooter extends StatelessWidget {
  const _AboutFooter({required this.version});

  final String version;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Column(
        children: [
          Text(
            'Freedom Smile',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),
          6.verticalSpace,
          Text(
            'Version $version',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
            ),
          ),
        ],
      ),
    );
  }
}
