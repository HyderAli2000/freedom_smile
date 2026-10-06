import 'package:shared_preferences/shared_preferences.dart';

class AppStorage {
  AppStorage._();

  static SharedPreferences? _prefs;

  static const _tokenKey = 'auth_token';
  static const _roleKey = 'user_role';
  static const _emailKey = 'user_email';
  static const _userIdKey = 'user_id';
  static const _deviceTokenKey = 'device_token';
  static const _profileCompleteKey = 'profile_complete';
  static const _profilePictureKey = 'profile_picture';
  static const _firstNameKey = 'first_name';
  static const _lastNameKey = 'last_name';
  static const _fullNameKey = 'full_name';
  static const _usernameKey = 'username';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static SharedPreferences get _p {
    final prefs = _prefs;
    if (prefs == null) {
      throw StateError('AppStorage.init() must be called before use.');
    }
    return prefs;
  }

  static String? get token => _p.getString(_tokenKey);

  static Future<void> setToken(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_tokenKey);
    } else {
      await _p.setString(_tokenKey, value);
    }
  }

  static String? get role => _p.getString(_roleKey);

  static Future<void> setRole(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_roleKey);
    } else {
      await _p.setString(_roleKey, value);
    }
  }

  static String? get email => _p.getString(_emailKey);

  static Future<void> setEmail(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_emailKey);
    } else {
      await _p.setString(_emailKey, value);
    }
  }

  static String? get userId => _p.getString(_userIdKey);

  static Future<void> setUserId(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_userIdKey);
    } else {
      await _p.setString(_userIdKey, value);
    }
  }

  static bool get isProfileComplete =>
      _p.getBool(_profileCompleteKey) ?? false;

  static Future<void> setProfileComplete(bool value) async {
    await _p.setBool(_profileCompleteKey, value);
  }

  static String? get profilePicture => _p.getString(_profilePictureKey);

  static Future<void> setProfilePicture(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_profilePictureKey);
    } else {
      await _p.setString(_profilePictureKey, value);
    }
  }

  static String? get firstName => _p.getString(_firstNameKey);

  static Future<void> setFirstName(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_firstNameKey);
    } else {
      await _p.setString(_firstNameKey, value);
    }
  }

  static String? get lastName => _p.getString(_lastNameKey);

  static Future<void> setLastName(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_lastNameKey);
    } else {
      await _p.setString(_lastNameKey, value);
    }
  }

  static String? get fullName => _p.getString(_fullNameKey);

  static Future<void> setFullName(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_fullNameKey);
    } else {
      await _p.setString(_fullNameKey, value);
    }
  }

  static String? get username => _p.getString(_usernameKey);

  static Future<void> setUsername(String? value) async {
    if (value == null || value.isEmpty) {
      await _p.remove(_usernameKey);
    } else {
      await _p.setString(_usernameKey, value);
    }
  }

  static String get displayName {
    final full = fullName?.trim();
    if (full != null && full.isNotEmpty) return full;
    final parts = <String>[];
    final first = firstName?.trim();
    final last = lastName?.trim();
    if (first != null && first.isNotEmpty) parts.add(first);
    if (last != null && last.isNotEmpty) parts.add(last);
    if (parts.isNotEmpty) return parts.join(' ');
    return email ?? '';
  }

  static String get greetingName {
    final first = firstName?.trim();
    if (first != null && first.isNotEmpty) return first;
    final full = displayName.trim();
    if (full.isEmpty) return 'there';
    return full.split(RegExp(r'\s+')).first;
  }

  static String get deviceToken =>
      _p.getString(_deviceTokenKey) ?? 'flutter-device-token';

  static Future<void> setDeviceToken(String value) async {
    await _p.setString(_deviceTokenKey, value);
  }

  static bool get isLoggedIn => token != null && token!.isNotEmpty;

  static Future<void> clearSession() async {
    await _p.remove(_tokenKey);
    await _p.remove(_roleKey);
    await _p.remove(_emailKey);
    await _p.remove(_userIdKey);
    await _p.remove(_profileCompleteKey);
    await _p.remove(_profilePictureKey);
    await _p.remove(_firstNameKey);
    await _p.remove(_lastNameKey);
    await _p.remove(_fullNameKey);
    await _p.remove(_usernameKey);
  }
}
