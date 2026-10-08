import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:freedom_smile/core/api/api_client.dart';
import 'package:freedom_smile/core/api/api_endpoints.dart';
import 'package:freedom_smile/core/api/api_response_parser.dart';
import 'package:freedom_smile/core/api/multipart_helper.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/data/models/api_models.dart';

class AuthService {
  AuthService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  String get _deviceType {
    if (kIsWeb) return 'Postman';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'IOS';
    return 'Postman';
  }

  Future<ApiResult> signup({
    required String email,
    required String password,
    required bool termsAccepted,
    String? referralCode,
  }) async {
    final res = await _client.post(
      ApiEndpoints.signup,
      data: {
        'email': email,
        'password': password,
        'confirmPassword': password,
        'termsAccepted': termsAccepted,
        if (referralCode != null && referralCode.isNotEmpty)
          'referralCode': referralCode,
        'deviceToken': AppStorage.deviceToken,
        'deviceType': _deviceType,
      },
    );
    return _parse(res.data, fallback: 'OTP sent');
  }

  Future<ApiResult> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
        'deviceToken': AppStorage.deviceToken,
        'deviceType': _deviceType,
      },
    );
    final result = _parse(res.data, fallback: 'Login successful');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> socialLogin({
    required String provider,
    required String email,
    required String socialId,
    String firstName = '',
    String lastName = '',
  }) async {
    final res = await _client.post(
      ApiEndpoints.socialLogin,
      data: {
        'provider': provider,
        'email': email,
        'socialId': socialId,
        'firstName': firstName,
        'lastName': lastName,
        'deviceToken': AppStorage.deviceToken,
        'deviceType': _deviceType,
      },
    );
    final result = _parse(res.data, fallback: 'Login successful');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> verifyOtp({
    required String email,
    required String otp,
    required String purpose,
  }) async {
    final res = await _client.post(
      ApiEndpoints.verifyOtp,
      data: {'email': email, 'otp': otp, 'purpose': purpose},
    );
    final result = _parse(res.data, fallback: 'OTP verified');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> sendOtp({
    required String email,
    String purpose = 'verify',
  }) async {
    final res = await _client.post(
      ApiEndpoints.sendOtp,
      data: {'email': email, 'purpose': purpose},
    );
    return _parse(res.data, fallback: 'OTP sent');
  }

  Future<ApiResult> forgotPassword({required String email}) async {
    final res = await _client.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
    return _parse(res.data, fallback: 'OTP sent');
  }

  Future<ApiResult> createProfile(
    Map<String, dynamic> body, {
    String? profilePicturePath,
  }) async {
    final data = await MultipartHelper.profilePayload(
      body,
      profilePicturePath: profilePicturePath,
    );
    final res = await _client.post(ApiEndpoints.createProfile, data: data);
    final result = _parse(res.data, fallback: 'Profile created');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> updateProfile(
    Map<String, dynamic> body, {
    String? profilePicturePath,
  }) async {
    final data = await MultipartHelper.profilePayload(
      body,
      profilePicturePath: profilePicturePath,
    );
    final res = await _client.put(ApiEndpoints.updateProfile, data: data);
    final result = _parse(res.data, fallback: 'Profile updated');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> getProfile() async {
    final res = await _client.get(ApiEndpoints.profile);
    final result = _parse(res.data, fallback: 'OK');
    await _persistSession(result);
    return result;
  }

  Future<ApiResult> sendPhoneOtp({
    required String phone,
    required String countryCode,
  }) async {
    final res = await _client.post(
      ApiEndpoints.sendPhoneOtp,
      data: {'phone': phone, 'countryCode': countryCode},
    );
    return _parse(res.data, fallback: 'OTP sent');
  }

  Future<ApiResult> verifyPhone({
    required String phone,
    required String countryCode,
    required String otp,
  }) async {
    final res = await _client.post(
      ApiEndpoints.verifyPhone,
      data: {'phone': phone, 'countryCode': countryCode, 'otp': otp},
    );
    return _parse(res.data, fallback: 'Phone verified');
  }

  Future<ApiResult> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final res = await _client.post(
      ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );
    return _parse(res.data, fallback: 'Password changed');
  }

  Future<ApiResult> resetPassword({
    required String password,
    required String confirmPassword,
  }) async {
    final res = await _client.post(
      ApiEndpoints.resetPassword,
      data: {'password': password, 'confirmPassword': confirmPassword},
    );
    return _parse(res.data, fallback: 'Password reset');
  }

  Future<ApiResult> updateLocation({
    required double latitude,
    required double longitude,
    String address = '',
    bool isLocationEnabled = true,
  }) async {
    final res = await _client.put(
      ApiEndpoints.updateLocation,
      data: {
        'latitude': latitude,
        'longitude': longitude,
        'address': address,
        'isLocationEnabled': isLocationEnabled,
      },
    );
    return _parse(res.data, fallback: 'Location updated');
  }

  Future<ApiResult> notificationToggle({
    required bool isNotificationEnabled,
  }) async {
    final res = await _client.put(
      ApiEndpoints.notificationToggle,
      data: {'isNotificationEnabled': isNotificationEnabled},
    );
    return _parse(res.data, fallback: 'Updated');
  }

  Future<ApiResult> updateLanguage({required String language}) async {
    final res = await _client.put(
      ApiEndpoints.language,
      data: {'language': language},
    );
    return _parse(res.data, fallback: 'Language updated');
  }

  Future<ApiResult> logout() async {
    try {
      final res = await _client.post(
        ApiEndpoints.logout,
        data: {'deviceToken': AppStorage.deviceToken},
      );
      final result = _parse(res.data, fallback: 'Logged out');
      await AppStorage.clearSession();
      return result;
    } catch (_) {
      await AppStorage.clearSession();
      rethrow;
    }
  }

  Future<ApiResult> deleteAccount({
    String? password,
    required String reason,
    String? reasonText,
  }) async {
    final res = await _client.delete(
      ApiEndpoints.deleteAccount,
      data: {
        'reason': reason,
        'reasonText': reasonText ?? '',
        if (password != null && password.isNotEmpty) 'password': password,
      },
    );
    final result = _parse(res.data, fallback: 'Account deleted');
    await AppStorage.clearSession();
    return result;
  }

  Future<void> _persistSession(ApiResult result) async {
    if (result.token != null && result.token!.isNotEmpty) {
      await AppStorage.setToken(result.token);
    }
    final user = result.user;
    if (user != null) {
      await AppStorage.setEmail(user.email);
      await AppStorage.setUserId(user.id);
      await AppStorage.setRole(user.userType);
      if (user.isProfileCompleted != null) {
        await AppStorage.setProfileComplete(user.isProfileCompleted!);
      }
      if (user.profilePicture != null) {
        await AppStorage.setProfilePicture(
          user.profilePicture!.trim().isEmpty ? null : user.profilePicture,
        );
      }
      if (user.firstName != null) {
        await AppStorage.setFirstName(user.firstName);
      }
      if (user.lastName != null) {
        await AppStorage.setLastName(user.lastName);
      }
      if (user.fullName != null) {
        await AppStorage.setFullName(user.fullName);
      }
      if (user.username != null) {
        await AppStorage.setUsername(user.username);
      }
    }
  }

  ApiResult _parse(dynamic data, {required String fallback}) {
    final root = ApiResponseParser.asMap(data);
    final userMap = ApiResponseParser.extractUser(data);
    return ApiResult(
      message: ApiResponseParser.message(data, fallback),
      token: ApiResponseParser.extractToken(data),
      user: userMap != null ? AuthUser.fromJson(userMap) : null,
      data: ApiResponseParser.dataMap(data) ?? root['data'],
      raw: root,
    );
  }
}
