import 'package:freedom_smile/core/api/api_config.dart';
import 'package:freedom_smile/utils/assets_images.dart';

/// Small helpers for parsing Freedom Smile API `data` payloads.
class ApiMap {
  ApiMap._();

  /// Absolute http(s) URL for media, or null when missing / not resolvable.
  static String? resolveMediaUrl(dynamic url) {
    final s = str(url);
    if (s.isEmpty) return null;
    if (s.startsWith('http://') || s.startsWith('https://')) return s;
    if (s.startsWith('assets/')) return null;
    // Local device paths are not network URLs.
    if (s.startsWith('/') &&
        (s.startsWith('/data/') ||
            s.startsWith('/storage/') ||
            s.startsWith('/var/') ||
            s.startsWith('/Users/') ||
            s.startsWith('/tmp/'))) {
      return null;
    }
    if (RegExp(r'^[a-zA-Z]:[\\/]').hasMatch(s) || s.startsWith(r'\\')) {
      return null;
    }
    // Relative API upload path → origin of baseUrl (strip `/api/v1`).
    try {
      final base = Uri.parse(ApiConfig.baseUrl);
      final origin =
          '${base.scheme}://${base.host}${base.hasPort ? ':${base.port}' : ''}';
      if (s.startsWith('/')) return '$origin$s';
      // Only treat as relative if it looks like an upload/key path.
      if (s.contains('/') && !s.contains(' ')) return '$origin/$s';
      return null;
    } catch (_) {
      return null;
    }
  }

  static Map<String, dynamic> map(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return <String, dynamic>{};
  }

  static List<Map<String, dynamic>> mapList(dynamic value, [String? key]) {
    dynamic list = value;
    if (value is Map && key != null) list = value[key];
    if (list is! List) return const [];
    return list
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  static String str(dynamic value, [String fallback = '']) {
    if (value == null) return fallback;
    final s = value.toString().trim();
    return s.isEmpty ? fallback : s;
  }

  static String id(Map<String, dynamic> map) =>
      str(map['_id'] ?? map['id']);

  static bool boolVal(dynamic value, [bool fallback = false]) {
    if (value is bool) return value;
    if (value == 'true') return true;
    if (value == 'false') return false;
    return fallback;
  }

  static int intVal(dynamic value, [int fallback = 0]) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static double doubleVal(dynamic value, [double fallback = 0]) {
    if (value is double) return value;
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static String formatSeconds(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:'
        '${m.toString().padLeft(2, '0')}:'
        '${s.toString().padLeft(2, '0')}';
  }

  static String imageOrFallback(dynamic url, [String fallback = AssetImages.pc1]) {
    return resolveMediaUrl(url) ?? fallback;
  }

  static bool isNetworkImage(dynamic url) => resolveMediaUrl(url) != null;

  static String formatDate(dynamic value) {
    if (value == null) return '';
    final dt = DateTime.tryParse(value.toString());
    if (dt == null) return str(value);
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String relativeTime(dynamic value) {
    final dt = DateTime.tryParse(value?.toString() ?? '');
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return formatDate(value);
  }
}
