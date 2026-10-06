import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/content_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class AboutAppScreen extends StatefulWidget {
  const AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  static const _fallbackVersion = '1.0.0';

  bool _loading = true;
  String _heading = '';
  String _body = '';
  String _version = _fallbackVersion;

  @override
  void initState() {
    super.initState();
    _heading = 'about_section_heading'.tr;
    _body = 'about_section_body'.tr;
    _loadAbout();
  }

  Future<void> _loadAbout() async {
    try {
      final result = await ContentService().getCms('about');
      final data = result.data;
      if (data is Map) {
        final page = data['page'];
        if (page is Map) {
          final map = Map<String, dynamic>.from(page);
          final title = (map['title'] ?? '').toString();
          final content = (map['content'] ?? map['body'] ?? '').toString();
          final version = (map['version'] ?? '').toString();
          if (title.isNotEmpty) _heading = title;
          if (content.isNotEmpty) _body = content;
          if (version.isNotEmpty) _version = version;
        }
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep localized fallback copy.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

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
                child: PageHeader(
                  title: 'about_app'.tr,
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
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding:
                              EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 24.h),
                          child: _AboutSection(
                            heading: _heading,
                            body: _body,
                          ),
                        ),
                ),
              ),
              _AboutFooter(version: _version),
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
            'app_name'.tr,
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
            'version_label'.trParams({'version': version}),
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
