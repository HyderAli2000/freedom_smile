import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
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
  String _selectedCategory = 'All';

  List<EducationalTip> get _filteredTips {
    if (_selectedCategory == 'All') {
      return EducationalTipsData.tips;
    }
    return EducationalTipsData.tips
        .where((tip) => tip.category == _selectedCategory)
        .toList();
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
              const PageHeader(title: 'Educational Tips'),
              16.verticalSpace,
              SizedBox(
                height: 40.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: EducationalTipsData.categories.length,
                  separatorBuilder: (_, _) => 10.horizontalSpace,
                  itemBuilder: (context, index) {
                    final category = EducationalTipsData.categories[index];
                    final isSelected = _selectedCategory == category;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedCategory = category);
                      },
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
                          category,
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
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                  itemCount: _filteredTips.length,
                  itemBuilder: (context, index) {
                    final tip = _filteredTips[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: EducationalTipListCard(
                        tip: tip,
                        onTap: () {
                          Get.to(() => EducationalTipDetailScreen(tip: tip));
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
