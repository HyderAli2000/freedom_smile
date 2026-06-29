import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  static const _referralCode = '#494944';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _ReferHeroSection(),
            24.verticalSpace,
            const _RewardsProgressCard(),
            28.verticalSpace,
            const _InviteFriendsSection(code: _referralCode),
            28.verticalSpace,
            const _ReferralStatusTracker(),
            28.verticalSpace,
            const _EarnedRewardSection(),
          ],
        ),
      ),
    );
  }
}

class _ReferHeroSection extends StatelessWidget {
  const _ReferHeroSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120.w,
          height: 120.w,
          padding: EdgeInsets.all(30.w),
          decoration: const BoxDecoration(
            color: AppColor.primaryBlue,
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            AssetImages.gift,
            fit: BoxFit.contain,
            // size: 40.sp,
          ),
        ),
        20.verticalSpace,
        Text(
          'Refer & Earn Rewards',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 22.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        12.verticalSpace,
        Text(
          'Invite friends and earn exciting rewards as\nthey join and complete their first order.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textBody,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _RewardsProgressCard extends StatelessWidget {
  const _RewardsProgressCard();

  static const _milestones = [
    '1 Referral -> \$100 Gift Card',
    '2 Referrals -> Miami Heat tickets (regular season)',
    '3 Referrals -> Free Retainer',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColor.calendarBg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rewards Progress',
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    14.verticalSpace,
                    ..._milestones.map(
                      (line) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Text(
                          line,
                          style: TextStyle(
                            fontFamily: AppFonts.family,
                            fontFamilyFallback: AppFonts.fallback,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColor.borderLightBlue,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              10.horizontalSpace,
              Container(
                width: 80.w,
                height: 80.w,
                padding: EdgeInsets.all(20.w),
                decoration: const BoxDecoration(
                  color: AppColor.whiteColor,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  AssetImages.gift,
                  color: AppColor.primaryBlue,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          18.verticalSpace,
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: const BoxDecoration(
                  color: AppColor.whiteColor,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(5.w),
                child: Image.asset(
                  AssetIcons.teeth1,
                  color: AppColor.primaryBlue,
                  fit: BoxFit.contain,
                ),
              ),
              10.horizontalSpace,
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999.r),
                  child: LinearProgressIndicator(
                    value: 2 / 3,
                    minHeight: 8.h,
                    backgroundColor: AppColor.whiteColor.withValues(
                      alpha: 0.28,
                    ),
                    color: AppColor.whiteColor,
                  ),
                ),
              ),
            ],
          ),
          8.verticalSpace,
          Text(
            '2/3 Completed',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColor.whiteColor.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

class _InviteFriendsSection extends StatelessWidget {
  const _InviteFriendsSection({required this.code});

  final String code;

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Referral code copied'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Invite Friends',
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
          'Share this code with your friends',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.textBody,
          ),
        ),
        14.verticalSpace,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: AppColor.profileOptionBg.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(9999999.r),
            border: Border.all(color: AppColor.primaryBlue),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  code,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColor.textDark,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _copyCode(context),
                child: Icon(
                  Icons.copy_rounded,
                  color: AppColor.primaryBlue,
                  size: 22.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReferralStatusTracker extends StatelessWidget {
  const _ReferralStatusTracker();

  static const _referrals = [
    _ReferralPerson(name: 'Kelvin', id: '#0012', status: 'Registered'),
    _ReferralPerson(
      name: 'John',
      id: '#0011',
      status: 'Approved',
      approved: true,
    ),
    _ReferralPerson(
      name: 'Mick',
      id: '#0013',
      status: 'Approved',
      approved: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Referral Status Tracker',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        Row(
          children: _referrals
              .map(
                (person) =>
                    Expanded(child: _ReferralPersonCard(person: person)),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _ReferralPerson {
  const _ReferralPerson({
    required this.name,
    required this.id,
    required this.status,
    this.approved = false,
  });

  final String name;
  final String id;
  final String status;
  final bool approved;
}

class _ReferralPersonCard extends StatelessWidget {
  const _ReferralPersonCard({required this.person});

  final _ReferralPerson person;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundImage: AssetImage(AssetImages.p1),
            ),
            if (person.approved)
              Positioned(
                right: -2.w,
                top: -2.h,
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: const BoxDecoration(
                    color: AppColor.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColor.whiteColor,
                    size: 14.sp,
                  ),
                ),
              ),
          ],
        ),
        8.verticalSpace,
        Text(
          '${person.name}\n${person.id}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColor.textDark,
            height: 1.3,
          ),
        ),
        4.verticalSpace,
        Text(
          person.status,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.primaryBlue,
          ),
        ),
      ],
    );
  }
}

class _EarnedRewardSection extends StatelessWidget {
  const _EarnedRewardSection();

  static const _rewards = [
    _RewardItem(
      image: AssetImages.gift,
      title: '\$100 Amazon Gift Card',
      status: 'Earned',
      earned: true,
    ),
    _RewardItem(
      image: AssetImages.pc3,
      title: 'Miami Heat Tickets',
      status: 'Earned',
      earned: true,
    ),
    _RewardItem(
      image: AssetImages.pc2,
      title: 'Free Retainer',
      status: 'Waiting',
      earned: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Earned Reward',
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
          'Next Reward: Free Retainer',
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            color: AppColor.textBody,
          ),
        ),
        16.verticalSpace,
        ..._rewards.map(
          (reward) => Padding(
            padding: EdgeInsets.only(bottom: 12.h),
            child: _RewardCard(reward: reward),
          ),
        ),
      ],
    );
  }
}

class _RewardItem {
  const _RewardItem({
    required this.image,
    required this.title,
    required this.status,
    required this.earned,
  });

  final String image;
  final String title;
  final String status;
  final bool earned;
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.reward});

  final _RewardItem reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColor.profileOptionBg.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColor.borderLightBlue.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.asset(
              reward.image,
              width: 72.w,
              height: 72.w,
              fit: BoxFit.cover,
            ),
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.title,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColor.textDark,
                  ),
                ),
                8.verticalSpace,
                Row(
                  children: [
                    if (reward.earned) ...[
                      Icon(
                        Icons.check_circle_rounded,
                        color: AppColor.primaryBlue,
                        size: 16.sp,
                      ),
                      6.horizontalSpace,
                    ],
                    Text(
                      reward.status,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: reward.earned
                            ? AppColor.primaryBlue
                            : AppColor.textBody,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
