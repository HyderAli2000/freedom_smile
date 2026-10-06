import 'package:flutter/material.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:get/get.dart';

class ApiSnackbar {
  ApiSnackbar._();

  static void success(String message, {String title = 'Success'}) {
    if (message.trim().isEmpty) return;
    Get.closeAllSnackbars();
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: const Duration(seconds: 2),
      isDismissible: true,
    );
  }

  static void error(
    String message, {
    String title = 'Error',
    int? statusCode,
    List<ApiFieldError> errors = const [],
  }) {
    Get.closeAllSnackbars();

    final lines = errors.isNotEmpty
        ? errors.map((e) => '• ${e.display}').toList()
        : message
            .split('\n')
            .where((l) => l.trim().isNotEmpty)
            .map((l) => l.startsWith('•') ? l : '• ${l.trim()}')
            .toList();

    final body = lines.isEmpty ? message : lines.join('\n');
    final durationSeconds = (lines.length > 2 ? 5 : 3).clamp(2, 8);

    Get.snackbar(
      title,
      body,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.shade700,
      colorText: Colors.white,
      margin: const EdgeInsets.all(12),
      borderRadius: 12,
      duration: Duration(seconds: durationSeconds),
      isDismissible: true,
      maxWidth: 420,
      messageText: Text(
        body,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13.5,
          height: 1.35,
        ),
      ),
      titleText: Text(
        statusCode != null ? '$title ($statusCode)' : title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  static void fromException(ApiException e) {
    error(
      e.message,
      title: e.title,
      statusCode: e.statusCode,
      errors: e.errors,
    );
  }
}
