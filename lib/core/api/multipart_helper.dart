import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

class MultipartHelper {
  MultipartHelper._();

  static String _basename(String path) {
    final normalized = path.replaceAll('\\', '/');
    final parts = normalized.split('/');
    return parts.isEmpty ? path : parts.last;
  }

  static bool isLocalFilePath(String? path) {
    if (path == null) return false;
    final trimmed = path.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return false;
    }
    if (trimmed.startsWith('content://') || trimmed.startsWith('assets/')) {
      return false;
    }
    try {
      return File(trimmed).existsSync();
    } catch (_) {
      return false;
    }
  }

  static Future<MultipartFile?> fileFromPath(
    String? path, {
    String fieldFallbackName = 'file',
  }) async {
    if (!isLocalFilePath(path)) return null;
    final trimmed = path!.trim();
    final name = _basename(trimmed);
    final filename = name.isEmpty ? fieldFallbackName : name;
    final bytes = await File(trimmed).readAsBytes();
    return MultipartFile.fromBytes(bytes, filename: filename);
  }

  static dynamic _encodeValue(dynamic value) {
    if (value == null) return null;
    if (value is MultipartFile) return value;
    if (value is Map || value is List) return jsonEncode(value);
    if (value is bool || value is num) return value.toString();
    return value.toString();
  }

  /// Returns [FormData] when uploading a local image, otherwise a plain JSON map.
  /// Always sending multipart was causing silent connection drops on some devices.
  static Future<dynamic> profilePayload(
    Map<String, dynamic> body, {
    String? profilePicturePath,
  }) async {
    final picture = await fileFromPath(
      profilePicturePath,
      fieldFallbackName: 'profilePicture.jpg',
    );
    if (picture == null) {
      return Map<String, dynamic>.from(body);
    }

    final map = <String, dynamic>{};
    body.forEach((key, value) {
      final encoded = _encodeValue(value);
      if (encoded != null) map[key] = encoded;
    });
    map['profilePicture'] = picture;
    return FormData.fromMap(map);
  }

  static Future<FormData> profileFormData(
    Map<String, dynamic> body, {
    String? profilePicturePath,
  }) async {
    final payload = await profilePayload(
      body,
      profilePicturePath: profilePicturePath,
    );
    if (payload is FormData) return payload;

    final map = <String, dynamic>{};
    body.forEach((key, value) {
      final encoded = _encodeValue(value);
      if (encoded != null) map[key] = encoded;
    });
    return FormData.fromMap(map);
  }
}
