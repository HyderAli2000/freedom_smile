import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/educational_tips_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:freedom_smile/widgets/educational/educational_tip_card.dart';

class EducationalTipDetailScreen extends StatefulWidget {
  const EducationalTipDetailScreen({super.key, required this.tip});

  final EducationalTip tip;

  @override
  State<EducationalTipDetailScreen> createState() =>
      _EducationalTipDetailScreenState();
}

class _EducationalTipDetailScreenState
    extends State<EducationalTipDetailScreen> {
  late EducationalTip _tip;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tip = widget.tip;
    final id = _tip.id;
    if (id != null && id.isNotEmpty) {
      _loadDetail(id);
    }
  }

  Future<void> _loadDetail(String id) async {
    setState(() => _loading = true);
    try {
      final result = await UserService().tipDetail(id);
      final data = ApiMap.map(result.data);
      final tipMap = ApiMap.map(data['tip'] ?? data);
      if (tipMap.isNotEmpty && mounted) {
        setState(() => _tip = EducationalTip.fromJson(tipMap));
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      // Keep passed-in tip.
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
              const PageHeader(title: 'Educational Tips'),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: EducationalTipImage(
                                tip: _tip,
                                height: 220.h,
                              ),
                            ),
                            20.verticalSpace,
                            Text(
                              _tip.title,
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColor.textDark,
                                height: 1.3,
                              ),
                            ),
                            16.verticalSpace,
                            Text(
                              _tip.body,
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
