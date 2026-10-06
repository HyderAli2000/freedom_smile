/// Helpers for Freedom Smile response shape:
/// `{ status, success, message, data }`
class ApiResponseParser {
  ApiResponseParser._();

  static Map<String, dynamic> asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return <String, dynamic>{};
  }

  static Map<String, dynamic>? dataMap(dynamic responseData) {
    final root = asMap(responseData);
    final nested = root['data'];
    if (nested is Map) return Map<String, dynamic>.from(nested);
    return root.isEmpty ? null : root;
  }

  static List<dynamic> dataList(dynamic responseData) {
    final root = asMap(responseData);
    final nested = root['data'];
    if (nested is List) return nested;
    if (nested is Map) {
      for (final key in ['items', 'list', 'results', 'docs', 'faqs', 'tips']) {
        final value = nested[key];
        if (value is List) return value;
      }
    }
    return const [];
  }

  static String? extractToken(dynamic responseData) {
    final root = asMap(responseData);
    final data = dataMap(responseData) ?? {};
    final candidates = <dynamic>[
      root['token'],
      root['accessToken'],
      data['token'],
      data['accessToken'],
    ];
    for (final c in candidates) {
      if (c is String && c.trim().isNotEmpty) return c.trim();
    }
    return null;
  }

  static String message(dynamic responseData, [String fallback = 'Success']) {
    final root = asMap(responseData);
    final msg = root['message'] ?? root['msg'];
    if (msg is String && msg.trim().isNotEmpty) return msg;
    return fallback;
  }

  static bool isSuccess(dynamic responseData) {
    final root = asMap(responseData);
    final success = root['success'];
    if (success is bool) return success;
    final status = root['status'];
    if (status is int) return status >= 200 && status < 300;
    return true;
  }

  static Map<String, dynamic>? extractUser(dynamic responseData) {
    final root = asMap(responseData);
    final data = dataMap(responseData);
    final candidates = <dynamic>[
      root['user'],
      if (data != null) data['user'],
      data,
    ];
    for (final c in candidates) {
      if (c is Map &&
          (c.containsKey('email') ||
              c.containsKey('_id') ||
              c.containsKey('id'))) {
        return Map<String, dynamic>.from(c);
      }
    }
    return null;
  }
}
