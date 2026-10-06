import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/content_service.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  final _service = UserService();
  final _contentService = ContentService();
  bool _loading = true;
  String _code = '';
  int _approvedCount = 0;
  int _goalCount = 3;
  double _progressPercent = 0;
  List<String> _tierLabels = const [];
  List<_ReferralPerson> _referrals = const [];
  List<_RewardItem> _rewards = const [];
  String _nextRewardLabel = '';

  @override
  void initState() {
    super.initState();
    _load();
  }

  List<_RewardItem> _mapTiers(
    List<Map<String, dynamic>> tiers, {
    required int approvedCount,
  }) {
    final sorted = [...tiers]..sort((a, b) {
      final ar = ApiMap.intVal(a['referralsRequired'] ?? a['sortOrder']);
      final br = ApiMap.intVal(b['referralsRequired'] ?? b['sortOrder']);
      return ar.compareTo(br);
    });

    return sorted.map((t) {
      final required = ApiMap.intVal(t['referralsRequired']);
      final earned = ApiMap.boolVal(t['unlocked'] ?? t['earned'] ?? t['completed']) ||
          (required > 0 && approvedCount >= required);
      final title = ApiMap.str(
        t['title'] ?? t['name'] ?? t['reward'],
        'Reward',
      );
      return _RewardItem(
        image: ApiMap.imageOrFallback(
          t['image'] ?? t['icon'],
          AssetImages.gift,
        ),
        title: title,
        statusKey: earned ? 'status_earned' : 'status_waiting',
        earned: earned,
        referralsRequired: required,
      );
    }).toList();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      // Postman: GET /user/referrals (includes earned tiers via unlocked)
      final result = await _service.referralSummary();
      final data = ApiMap.map(result.data);
      _code = ApiMap.str(data['code'] ?? data['referralCode']);
      _approvedCount = ApiMap.intVal(data['approvedCount']);
      _progressPercent = ApiMap.doubleVal(data['progressPercent']);
      if (_progressPercent > 1) _progressPercent = _progressPercent / 100;

      var tiers = ApiMap.mapList(data, 'tiers');
      // Fallback: public reward tiers if summary has none
      if (tiers.isEmpty) {
        try {
          final tiersResult = await _contentService.listRewardTiers();
          final tiersData = ApiMap.map(tiersResult.data);
          tiers = ApiMap.mapList(tiersData, 'tiers');
          if (tiers.isEmpty) tiers = ApiMap.mapList(tiersResult.data);
        } catch (_) {
          // Keep empty; section will show empty state.
        }
      }

      _rewards = _mapTiers(tiers, approvedCount: _approvedCount);
      _tierLabels = _rewards.map((r) => r.title).where((e) => e.isNotEmpty).toList();
      _goalCount = _rewards.isEmpty
          ? 3
          : _rewards
              .map((r) => r.referralsRequired)
              .fold<int>(0, (max, v) => v > max ? v : max);
      if (_goalCount <= 0) _goalCount = _rewards.length;

      final next = _rewards.where((r) => !r.earned).firstOrNull;
      _nextRewardLabel = next == null
          ? 'All rewards unlocked'
          : 'Next Reward: ${next.title}';

      final referrals = ApiMap.mapList(data, 'referrals');
      _referrals = referrals.map((r) {
        final referred = ApiMap.map(r['referredUser'] ?? r['user']);
        final status = ApiMap.str(r['status']).toLowerCase();
        final approved = status == 'approved' || status == 'completed';
        final name = ApiMap.str(
          referred['fullName'] ??
              referred['firstName'] ??
              r['name'] ??
              r['fullName'] ??
              r['username'],
          'Friend',
        );
        final id = ApiMap.id(r);
        final shortId =
            id.length > 4 ? '#${id.substring(id.length - 4)}' : '#$id';
        return _ReferralPerson(
          name: name,
          id: shortId,
          statusKey: approved ? 'status_approved' : 'status_registered',
          approved: approved,
          image: ApiMap.imageOrFallback(
            referred['profilePicture'] ?? r['profilePicture'],
          ),
        );
      }).toList();
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _load,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ReferHeroSection(),
              24.verticalSpace,
              _RewardsProgressCard(
                progress: _progressPercent,
                approvedCount: _approvedCount,
                goalCount: _goalCount,
                tierLabels: _tierLabels,
              ),
              28.verticalSpace,
              _InviteFriendsSection(code: _code.isEmpty ? '—' : _code),
              28.verticalSpace,
              _ReferralStatusTracker(referrals: _referrals),
              28.verticalSpace,
              _EarnedRewardSection(
                rewards: _rewards,
                nextRewardLabel: _nextRewardLabel,
              ),
            ],
          ),
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
          ),
        ),
        20.verticalSpace,
        Text(
          'refer_and_earn'.tr,
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
          'refer_hero_description'.tr,
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
  const _RewardsProgressCard({
    required this.progress,
    required this.approvedCount,
    required this.goalCount,
    required this.tierLabels,
  });

  final double progress;
  final int approvedCount;
  final int goalCount;
  final List<String> tierLabels;

  @override
  Widget build(BuildContext context) {
    final labels = tierLabels.isNotEmpty
        ? tierLabels
        : ['milestone_1'.tr, 'milestone_2'.tr, 'milestone_3'.tr];
    final goal = goalCount > 0 ? goalCount : labels.length;
    final fractionLabel = '$approvedCount/$goal Completed';

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
                      'rewards_progress'.tr,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.whiteColor,
                      ),
                    ),
                    14.verticalSpace,
                    ...labels.map(
                      (label) => Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Text(
                          label,
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
                    value: progress.clamp(0.0, 1.0),
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
            fractionLabel,
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
        content: Text('referral_code_copied'.tr),
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
          'invite_friends'.tr,
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
          'share_code_with_friends'.tr,
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
  const _ReferralStatusTracker({required this.referrals});

  final List<_ReferralPerson> referrals;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'referral_status_tracker'.tr,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        16.verticalSpace,
        if (referrals.isEmpty)
          Text(
            'No referrals yet',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              color: AppColor.textBody,
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: referrals
                  .map(
                    (person) => Padding(
                      padding: EdgeInsets.only(right: 16.w),
                      child: _ReferralPersonCard(person: person),
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _ReferralPerson {
  const _ReferralPerson({
    required this.name,
    required this.id,
    required this.statusKey,
    this.approved = false,
    this.image = AssetImages.p1,
  });

  final String name;
  final String id;
  final String statusKey;
  final bool approved;
  final String image;
}

class _ReferralPersonCard extends StatelessWidget {
  const _ReferralPersonCard({required this.person});

  final _ReferralPerson person;

  ImageProvider _avatar() {
    final src = person.image;
    final network = ApiMap.resolveMediaUrl(src);
    if (network != null) return NetworkImage(network);
    return AssetImage(src);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 32.r,
              backgroundImage: _avatar(),
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
          person.statusKey.tr,
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
  const _EarnedRewardSection({
    required this.rewards,
    required this.nextRewardLabel,
  });

  final List<_RewardItem> rewards;
  final String nextRewardLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'earned_reward'.tr,
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColor.textDark,
          ),
        ),
        if (nextRewardLabel.isNotEmpty) ...[
          6.verticalSpace,
          Text(
            nextRewardLabel,
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColor.textBody,
            ),
          ),
        ],
        16.verticalSpace,
        if (rewards.isEmpty)
          Text(
            'No rewards available yet',
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontFamilyFallback: AppFonts.fallback,
              fontSize: 13.sp,
              color: AppColor.textBody,
            ),
          )
        else
          ...rewards.map(
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
    required this.statusKey,
    required this.earned,
    this.title = '',
    this.referralsRequired = 0,
  });

  final String image;
  final String title;
  final String statusKey;
  final bool earned;
  final int referralsRequired;

  String get displayTitle => title;
}

class _RewardCard extends StatelessWidget {
  const _RewardCard({required this.reward});

  final _RewardItem reward;

  Widget _thumb() {
    final src = reward.image;
    final network = ApiMap.resolveMediaUrl(src);
    if (network != null) {
      return Image.network(
        network,
        width: 72.w,
        height: 72.w,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Image.asset(
          AssetImages.gift,
          width: 72.w,
          height: 72.w,
          fit: BoxFit.cover,
        ),
      );
    }
    return Image.asset(
      src,
      width: 72.w,
      height: 72.w,
      fit: BoxFit.cover,
    );
  }

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
            child: _thumb(),
          ),
          14.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reward.displayTitle,
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
                      reward.statusKey.tr,
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
