import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum NotificationKind { reminder, habit, feature, reward, referral }

class NotificationItem {
  const NotificationItem({
    required this.kind,
    required this.title,
    required this.body,
    required this.timestamp,
    this.icon,
    this.showActions = false,
  });

  final NotificationKind kind;
  final String title;
  final String body;
  final String timestamp;
  final IconData? icon;
  final bool showActions;
}

class NotificationsData {
  NotificationsData._();

  static String get _reminderTitle => 'notification_reminder_title'.tr;
  static String get _reminderBody => 'notification_reminder_body'.tr;
  static String get _habitTitle => 'notification_habit_title'.tr;
  static String get _habitBody => 'notification_habit_body'.tr;
  static String get _featureTitle => 'notification_feature_title'.tr;
  static String get _featureBody => 'notification_feature_body'.tr;
  static String get _rewardTitle => 'notification_reward_title'.tr;
  static String get _rewardBody => 'notification_reward_body'.tr;
  static String get _referralTitle => 'notification_referral_title'.tr;
  static String get _referralBody => 'notification_referral_body'.tr;
  static String get _timestampToday => 'timestamp_today'.tr;
  static String get _timestampYesterday => 'timestamp_yesterday'.tr;
  static String get _timestampMon => 'timestamp_mon'.tr;
  static String get _timestampSun => 'timestamp_sun'.tr;

  static List<NotificationItem> get items => [
    NotificationItem(
      kind: NotificationKind.reminder,
      title: _reminderTitle,
      body: _reminderBody,
      timestamp: _timestampToday,
      icon: Icons.access_time_rounded,
      showActions: true,
    ),
    NotificationItem(
      kind: NotificationKind.habit,
      title: _habitTitle,
      body: _habitBody,
      timestamp: _timestampToday,
      icon: Icons.bolt_rounded,
    ),
    NotificationItem(
      kind: NotificationKind.feature,
      title: _featureTitle,
      body: _featureBody,
      timestamp: _timestampYesterday,
    ),
    NotificationItem(
      kind: NotificationKind.reward,
      title: _rewardTitle,
      body: _rewardBody,
      timestamp: _timestampMon,
      icon: Icons.star_rounded,
    ),
    NotificationItem(
      kind: NotificationKind.referral,
      title: _referralTitle,
      body: _referralBody,
      timestamp: _timestampSun,
      icon: Icons.card_giftcard_rounded,
    ),
  ];
}
