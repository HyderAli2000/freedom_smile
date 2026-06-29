class AppointmentItem {
  const AppointmentItem({
    required this.id,
    required this.title,
    required this.time,
    required this.rating,
    required this.reviewCount,
    required this.imageAsset,
    required this.isCompleted,
    this.initialHour = 2,
    this.initialIsAm = false,
  });

  final String id;
  final String title;
  final String time;
  final double rating;
  final String reviewCount;
  final String imageAsset;
  final bool isCompleted;
  final int initialHour;
  final bool initialIsAm;
}

class AppointmentsData {
  AppointmentsData._();

  static const items = <AppointmentItem>[
    AppointmentItem(
      id: '#21646',
      title: 'Lorem Ipsum Orthodontist',
      time: '02:00 PM',
      rating: 4.7,
      reviewCount: '50+',
      imageAsset: 'assets/images/pc1.png',
      isCompleted: false,
      initialHour: 2,
      initialIsAm: false,
    ),
    AppointmentItem(
      id: '#21647',
      title: 'Lorem Ipsum Orthodontist',
      time: '04:30 PM',
      rating: 4.8,
      reviewCount: '32+',
      imageAsset: 'assets/images/pc2.png',
      isCompleted: false,
      initialHour: 4,
      initialIsAm: false,
    ),
    AppointmentItem(
      id: '#21648',
      title: 'Lorem Ipsum Orthodontist',
      time: '11:00 AM',
      rating: 4.6,
      reviewCount: '18+',
      imageAsset: 'assets/images/pc3.png',
      isCompleted: true,
      initialHour: 11,
      initialIsAm: true,
    ),
    AppointmentItem(
      id: '#21649',
      title: 'Lorem Ipsum Orthodontist',
      time: '09:15 AM',
      rating: 4.9,
      reviewCount: '64+',
      imageAsset: 'assets/images/pc4.png',
      isCompleted: true,
      initialHour: 9,
      initialIsAm: true,
    ),
  ];
}
