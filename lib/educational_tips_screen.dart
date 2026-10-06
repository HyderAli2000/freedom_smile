import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/educational_tip_detail_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/educational/educational_tip_card.dart';
import 'package:get/get.dart';

class EducationalTipsScreen extends StatefulWidget {
  const EducationalTipsScreen({super.key});

  @override
  State<EducationalTipsScreen> createState() => _EducationalTipsScreenState();
}

class _EducationalTipsScreenState extends State<EducationalTipsScreen> {
  final _userService = UserService();

  bool _loading = true;
  bool _tipsLoading = false;
  String _selectedSlug = '';
  List<TipCategoryItem> _categories = const [];
  List<EducationalTip> _tips = EducationalTipsData.tips;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    try {
      final results = await Future.wait([
        _userService.listTipCategories(),
        _userService.listTips(),
      ]);

      final catData = ApiMap.map(results[0].data);
      final tipData = ApiMap.map(results[1].data);
      final cats = ApiMap.mapList(catData, 'categories');
      final tips = ApiMap.mapList(tipData, 'tips');

      if (mounted) {
        setState(() {
          if (cats.isNotEmpty) {
            _categories = cats.map(TipCategoryItem.fromJson).toList();
          }
          if (tips.isNotEmpty) {
            _tips = tips.map(EducationalTip.fromJson).toList();
          }
        });
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep local fallbacks.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadTipsForCategory(String slug) async {
    setState(() {
      _selectedSlug = slug;
      _tipsLoading = true;
    });
    try {
      final result = await _userService.listTips(
        category: slug.isEmpty ? null : slug,
      );
      final tipData = ApiMap.map(result.data);
      final tips = ApiMap.mapList(tipData, 'tips');
      if (mounted && tips.isNotEmpty) {
        setState(() => _tips = tips.map(EducationalTip.fromJson).toList());
      } else if (mounted && tips.isEmpty) {
        setState(() => _tips = const []);
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep previous list.
    } finally {
      if (mounted) setState(() => _tipsLoading = false);
    }
  }

  List<({String label, String slug})> get _categoryChips {
    final chips = <({String label, String slug})>[
      (label: 'All', slug: ''),
    ];
    if (_categories.isNotEmpty) {
      for (final c in _categories) {
        chips.add((label: c.name, slug: c.slug));
      }
    } else {
      for (final name in EducationalTipsData.categories.skip(1)) {
        chips.add((label: name, slug: name));
      }
    }
    return chips;
  }

  @override
  Widget build(BuildContext context) {
    final chips = _categoryChips;

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
              const PageHeader(title: 'Educational Tips'),
              16.verticalSpace,
              if (_loading)
                const Expanded(
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                SizedBox(
                  height: 40.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: chips.length,
                    separatorBuilder: (_, _) => 10.horizontalSpace,
                    itemBuilder: (context, index) {
                      final category = chips[index];
                      final isSelected = _selectedSlug == category.slug;
                      return GestureDetector(
                        onTap: () => _loadTipsForCategory(category.slug),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 18.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColor.primaryBlue
                                : AppColor.profileOptionBg.withValues(
                                    alpha: 0.85,
                                  ),
                            borderRadius: BorderRadius.circular(999999.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category.label,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColor.whiteColor
                                  : AppColor.primaryBlue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                20.verticalSpace,
                Expanded(
                  child: _tipsLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _tips.isEmpty
                          ? Center(
                              child: Text(
                                'No tips found',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: AppColor.textBody,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding:
                                  EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                              itemCount: _tips.length,
                              itemBuilder: (context, index) {
                                final tip = _tips[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: EducationalTipListCard(
                                    tip: tip,
                                    onTap: () {
                                      Get.to(
                                        () => EducationalTipDetailScreen(
                                          tip: tip,
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
