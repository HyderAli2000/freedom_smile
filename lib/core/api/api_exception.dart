import 'package:dio/dio.dart';
import 'package:freedom_smile/core/api/api_config.dart';

class ApiFieldError {
  const ApiFieldError({this.field, required this.message});

  final String? field;
  final String message;

  String get display {
    if (field == null || field!.isEmpty) return message;
    return '$field: $message';
  }
}

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.data,
    this.errors = const [],
  });

  final String message;
  final int? statusCode;
  final dynamic data;
  final List<ApiFieldError> errors;

  String get title {
    switch (statusCode) {
      case 400:
        return errors.length > 1 ? 'Validation errors' : 'Bad request';
      case 401:
      case 410:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 409:
        return 'Conflict';
      case 422:
        return 'Validation failed';
      case 440:
        return 'Session expired';
      case 429:
        return 'Too many requests';
      case 500:
      case 502:
      case 503:
        return 'Server error';
      default:
        if (statusCode != null) return 'Error ($statusCode)';
        return 'Error';
    }
  }

  factory ApiException.fromDio(DioException error) {
    final status = error.response?.statusCode;
    final body = error.response?.data;

    var message = 'Something went wrong. Please try again.';
    var errors = <ApiFieldError>[];

    if (body is Map) {
      final map = Map<String, dynamic>.from(body);
      final parsed = _parseMessage(map['message'] ?? map['error'] ?? map['msg']);
      if (parsed.errors.isNotEmpty || parsed.message.isNotEmpty) {
        message = parsed.message.isNotEmpty ? parsed.message : message;
        errors = parsed.errors;
      }
      if (errors.isEmpty) {
        final alt = _parseMessage(map['errors'] ?? map['errorMessages']);
        if (alt.errors.isNotEmpty) {
          errors = alt.errors;
          message = alt.message;
        }
      }
    } else if (body is String && body.trim().isNotEmpty) {
      message = body.trim();
    } else if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout) {
      message =
          'Connection timed out.\nServer: ${ApiConfig.baseUrl}\nIs the backend running?';
    } else if (error.type == DioExceptionType.connectionError) {
      message =
          'Cannot reach server.\nServer: ${ApiConfig.baseUrl}\nCheck API_BASE_URL / device network.';
    } else if (error.type == DioExceptionType.cancel) {
      message = 'Request was cancelled.';
    } else if (error.error != null) {
      message =
          'Network error: ${error.error}\nServer: ${ApiConfig.baseUrl}';
    } else if (error.message != null && error.message!.isNotEmpty) {
      message = error.message!;
    } else {
      message =
          'No response from server.\nServer: ${ApiConfig.baseUrl}\nCheck adb reverse / backend logs.';
    }

    return ApiException(
      message: message,
      statusCode: status,
      data: body,
      errors: errors,
    );
  }

  static ({String message, List<ApiFieldError> errors}) _parseMessage(
    dynamic msg,
  ) {
    if (msg == null) {
      return (message: '', errors: <ApiFieldError>[]);
    }

    if (msg is String) {
      final trimmed = msg.trim();
      return (
        message: trimmed,
        errors: trimmed.isEmpty
            ? <ApiFieldError>[]
            : [ApiFieldError(message: trimmed)],
      );
    }

    if (msg is List) {
      final list = <ApiFieldError>[];
      for (final item in msg) {
        if (item is String && item.trim().isNotEmpty) {
          list.add(ApiFieldError(message: item.trim()));
        } else if (item is Map) {
          final field = (item['field'] ?? item['path'] ?? item['param'])
              ?.toString();
          final m = (item['message'] ?? item['msg'] ?? item['error'])
              ?.toString();
          if (m != null && m.trim().isNotEmpty) {
            list.add(
              ApiFieldError(
                field: field?.trim().isEmpty == true ? null : field?.trim(),
                message: m.trim(),
              ),
            );
          }
        }
      }
      if (list.isEmpty) {
        return (message: '', errors: <ApiFieldError>[]);
      }
      return (
        message: list.map((e) => e.display).join('\n'),
        errors: list,
      );
    }

    if (msg is Map) {
      final field = (msg['field'] ?? msg['path'])?.toString();
      final m = (msg['message'] ?? msg['msg'])?.toString();
      if (m != null && m.trim().isNotEmpty) {
        final err = ApiFieldError(field: field, message: m.trim());
        return (message: err.display, errors: [err]);
      }
    }

    return (message: msg.toString(), errors: <ApiFieldError>[]);
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
