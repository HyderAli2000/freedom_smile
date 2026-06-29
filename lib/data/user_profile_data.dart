class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.profileEmail,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.city,
    required this.state,
    required this.gender,
    required this.email,
    required this.countryCode,
    required this.phone,
  });

  final String displayName;
  final String profileEmail;
  final String firstName;
  final String lastName;
  final String address;
  final String city;
  final String state;
  final String gender;
  final String email;
  final String countryCode;
  final String phone;

  String get fullName => '$firstName $lastName';

  String get formattedPhone => '$countryCode $phone';

  UserProfile copyWith({
    String? displayName,
    String? profileEmail,
    String? firstName,
    String? lastName,
    String? address,
    String? city,
    String? state,
    String? gender,
    String? email,
    String? countryCode,
    String? phone,
  }) {
    return UserProfile(
      displayName: displayName ?? this.displayName,
      profileEmail: profileEmail ?? this.profileEmail,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      gender: gender ?? this.gender,
      email: email ?? this.email,
      countryCode: countryCode ?? this.countryCode,
      phone: phone ?? this.phone,
    );
  }

  static const sample = UserProfile(
    displayName: 'Anderson Roy',
    profileEmail: 'roy@domain.com',
    firstName: 'William',
    lastName: 'Roy',
    address:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, eiusmod tempor...',
    city: 'Albany',
    state: 'New York',
    gender: 'Male',
    email: 'roy@domain.com',
    countryCode: '+1',
    phone: '234 567 890',
  );
}
