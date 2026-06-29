import 'package:flutter/material.dart';

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

  static const items = <NotificationItem>[
    NotificationItem(
      kind: NotificationKind.reminder,
      title: 'Time to wear your retainer',
      body:
          'Reminder - Lorem ipsum dolor sit amet consectetur. Sit scelerisque nibh ullamcorper.',
      timestamp: 'Today',
      icon: Icons.access_time_rounded,
      showActions: true,
    ),
    NotificationItem(
      kind: NotificationKind.habit,
      title: 'Great habits build great smiles',
      body: "You're doing great—stay consistent this week",
      timestamp: 'Today',
      icon: Icons.bolt_rounded,
    ),
    NotificationItem(
      kind: NotificationKind.feature,
      title: "New features available. Check out what's new in your Freedom Smile",
      body:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
      timestamp: 'Yesterday',
    ),
    NotificationItem(
      kind: NotificationKind.reward,
      title: "Congratulations! You've earned a reward.",
      body: "You've unlocked your reward check it out now!",
      timestamp: 'Mon',
      icon: Icons.star_rounded,
    ),
    NotificationItem(
      kind: NotificationKind.referral,
      title: 'Your referral has been approved.',
      body: 'Nice! Your referral is now counted toward your rewards.',
      timestamp: 'Sun',
      icon: Icons.card_giftcard_rounded,
    ),
  ];
}
