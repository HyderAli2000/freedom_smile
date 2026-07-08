import 'package:get/get.dart';

class ChatListItem {
  const ChatListItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.avatarAsset,
  });

  final String name;
  final String lastMessage;
  final String time;
  final String avatarAsset;
}

class ChatListData {
  ChatListData._();

  static String get _doctorJennifer => 'chat_doctor_jennifer'.tr;
  static String get _doctorAnderson => 'chat_doctor_anderson'.tr;
  static String get _doctorWilliam => 'chat_doctor_william'.tr;
  static String get _clinicSupport => 'chat_clinic_support'.tr;
  static String get _lastMessageLorem => 'chat_last_message_lorem'.tr;
  static String get _lastMessageConfirmed => 'chat_last_message_confirmed'.tr;
  static String get _lastMessageWearTonight => 'chat_last_message_wear_tonight'.tr;
  static String get _lastMessageHelp => 'chat_last_message_help'.tr;
  static String get _time3pm => 'chat_time_3pm'.tr;

  static List<ChatListItem> get items => [
    ChatListItem(
      name: _doctorJennifer,
      lastMessage: _lastMessageLorem,
      time: _time3pm,
      avatarAsset: 'assets/images/pc1.png',
    ),
    ChatListItem(
      name: _doctorAnderson,
      lastMessage: _lastMessageConfirmed,
      time: 'Yesterday',
      avatarAsset: 'assets/images/pc2.png',
    ),
    ChatListItem(
      name: _doctorWilliam,
      lastMessage: _lastMessageWearTonight,
      time: 'Mon',
      avatarAsset: 'assets/images/pc3.png',
    ),
    ChatListItem(
      name: _clinicSupport,
      lastMessage: _lastMessageHelp,
      time: 'Sun',
      avatarAsset: 'assets/images/pc4.png',
    ),
  ];
}
