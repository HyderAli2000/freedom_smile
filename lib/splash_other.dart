import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/login_screen.dart';
import 'package:get/get.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class SplashOther extends StatefulWidget {
  const SplashOther({super.key});

  @override
  State<SplashOther> createState() => _SplashOtherState();
}

class _SplashOtherState extends State<SplashOther> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _pages = <_OnboardingPageData>[
    _OnboardingPageData(
      image: AssetImages.splash2,
      title: 'Keep Your Smile in Shape',
      description:
          'Never miss a day of wearing your retainer with smart daily reminders. Build healthy habits that protect your smile long-term.',
    ),
    _OnboardingPageData(
      image: AssetImages.splash3,
      title: 'Manage & Replace with Ease',
      description:
          'Track your retainer usage and get notified when it\'s time for a replacement. Order new retainers quickly without hassle or delays.',
    ),
    _OnboardingPageData(
      image: AssetImages.splash4,
      title: 'Stay Connected with Your Orthodontist',
      description:
          'Easily book appointments and stay in touch with your clinic anytime. Get guidance and support throughout your retention journey.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onSkip() {
    Get.off(() => const LoginScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AssetImages.background, fit: BoxFit.cover),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _OnboardingHeader(onSkip: _onSkip),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _OnboardingPage(data: _pages[index]);
                    },
                  ),
                ),
                _PageIndicator(
                  count: _pages.length,
                  currentIndex: _currentPage,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader({required this.onSkip});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            'Onboarding',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onSkip,
              style: TextButton.styleFrom(
                foregroundColor: AppColor.textDark,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Skip',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data});

  final _OnboardingPageData data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          40.verticalSpace,
          Image.asset(data.image, fit: BoxFit.contain),
          40.verticalSpace,
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.textDark,
              height: 1.25,
            ),
          ),
          16.verticalSpace,
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
              height: 1.55,
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.currentIndex});

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          width: isActive ? 48.w : 8.w,
          height: 8.h,
          decoration: BoxDecoration(
            color: isActive
                ? AppColor.indicatorActive
                : AppColor.indicatorInactive.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
