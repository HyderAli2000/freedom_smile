import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';

class EducationalTipDetailScreen extends StatelessWidget {
  const EducationalTipDetailScreen({super.key, required this.tip});

  final EducationalTip tip;

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
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.r),
                        child: Image.asset(
                          tip.image,
                          height: 220.h,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      20.verticalSpace,
                      Text(
                        tip.title,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.textDark,
                          height: 1.3,
                        ),
                      ),
                      16.verticalSpace,
                      Text(
                        tip.body,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColor.textBody,
                          height: 1.55,
                        ),
                      ),
                    ],
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
