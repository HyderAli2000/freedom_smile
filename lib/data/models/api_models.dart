class AuthUser {
  const AuthUser({
    this.id,
    this.email,
    this.userType,
    this.firstName,
    this.lastName,
    this.fullName,
    this.username,
    this.address,
    this.city,
    this.state,
    this.gender,
    this.countryCode,
    this.phone,
    this.language,
    this.referralCode,
    this.isNotificationEnabled,
    this.isProfileCompleted,
    this.isVerified,
    this.profilePicture,
  });

  final String? id;
  final String? email;
  final String? userType;
  final String? firstName;
  final String? lastName;
  final String? fullName;
  final String? username;
  final String? address;
  final String? city;
  final String? state;
  final String? gender;
  final String? countryCode;
  final String? phone;
  final String? language;
  final String? referralCode;
  final bool? isNotificationEnabled;
  final bool? isProfileCompleted;
  final bool? isVerified;
  final String? profilePicture;

  String get displayName {
    if (fullName != null && fullName!.trim().isNotEmpty) return fullName!.trim();
    final parts = [firstName, lastName]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .toList();
    if (parts.isNotEmpty) return parts.join(' ');
    return email ?? '';
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: (json['_id'] ?? json['id'])?.toString(),
      email: json['email']?.toString(),
      userType: json['userType']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      fullName: json['fullName']?.toString(),
      username: json['username']?.toString(),
      address: json['address']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      gender: json['gender']?.toString(),
      countryCode: json['countryCode']?.toString(),
      phone: json['phone']?.toString(),
      language: json['language']?.toString(),
      referralCode: json['referralCode']?.toString(),
      isNotificationEnabled: json['isNotificationEnabled'] as bool?,
      isProfileCompleted: json['isProfileCompleted'] as bool? ??
          json['isProfileComplete'] as bool?,
      isVerified: json['isVerified'] as bool?,
      profilePicture: (json['profilePicture'] ?? json['avatar'])?.toString(),
    );
  }
}

class ApiResult {
  const ApiResult({
    required this.message,
    this.token,
    this.user,
    this.data,
    this.raw = const {},
  });

  final String message;
  final String? token;
  final AuthUser? user;
  final dynamic data;
  final Map<String, dynamic> raw;
}
