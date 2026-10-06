import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/faqs_data.dart';
import 'package:freedom_smile/data/services/content_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  int? _expandedIndex = 0;
  bool _loading = true;
  List<FaqItem> _items = FaqsData.items;

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    try {
      final result = await ContentService().listFaqs();
      final data = result.data;
      List<dynamic> raw = const [];
      if (data is Map && data['faqs'] is List) {
        raw = data['faqs'] as List;
      } else if (data is List) {
        raw = data;
      }
      if (raw.isNotEmpty) {
        _items = raw.map((e) {
          final map = Map<String, dynamic>.from(e as Map);
          return FaqItem(
            question: (map['question'] ?? map['title'] ?? '').toString(),
            answer: (map['answer'] ?? map['body'] ?? '').toString(),
          );
        }).where((e) => e.question.isNotEmpty).toList();
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep local fallback.
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
                  title: 'faqs_title'.tr,
                  whiteBackButton: true,
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
                        children: [
                          Text(
                            'frequently_asked_questions_heading'.tr,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontFamilyFallback: AppFonts.fallback,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColor.textDark,
                              height: 1.25,
                            ),
                          ),
                          20.verticalSpace,
                          ...List.generate(_items.length, (index) {
                            final item = _items[index];
                            final isExpanded = _expandedIndex == index;
                            return Padding(
                              padding: EdgeInsets.only(bottom: 14.h),
                              child: _FaqExpansionTile(
                                question: item.question,
                                answer: item.answer,
                                isExpanded: isExpanded,
                                onTap: () {
                                  setState(() {
                                    _expandedIndex =
                                        isExpanded ? null : index;
                                  });
                                },
                              ),
                            );
                          }),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FaqExpansionTile extends StatelessWidget {
  const _FaqExpansionTile({
    required this.question,
    required this.answer,
    required this.isExpanded,
    required this.onTap,
  });

  final String question;
  final String answer;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: AppColor.whiteColor.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.5),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 12.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        question,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontFamilyFallback: AppFonts.fallback,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textDark,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      color: AppColor.primaryBlue,
                      size: 24.sp,
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  10.verticalSpace,
                  Text(
                    answer,
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColor.textBody,
                      height: 1.45,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
