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

  static const items = <ChatListItem>[
    ChatListItem(
      name: 'Dr Jennifer Vargas',
      lastMessage: 'Lorem ipsum dolor sit amet consectetur.',
      time: '3:37 AM',
      avatarAsset: 'assets/images/pc1.png',
    ),
    ChatListItem(
      name: 'Dr Anderson Smith',
      lastMessage: 'Your next appointment is confirmed.',
      time: 'Yesterday',
      avatarAsset: 'assets/images/pc2.png',
    ),
    ChatListItem(
      name: 'Dr William Roy',
      lastMessage: 'Please wear your retainer tonight.',
      time: 'Mon',
      avatarAsset: 'assets/images/pc3.png',
    ),
    ChatListItem(
      name: 'Clinic Support',
      lastMessage: 'How can we help you today?',
      time: 'Sun',
      avatarAsset: 'assets/images/pc4.png',
    ),
  ];
}
