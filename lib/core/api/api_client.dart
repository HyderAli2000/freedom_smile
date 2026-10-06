import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:freedom_smile/core/api/api_config.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';

/// Shared Dio client. Authorization header = raw JWT (no Bearer prefix).
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: const {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = AppStorage.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = token;
          }
          if (options.data is! FormData) {
            options.headers['Content-Type'] =
                options.headers['Content-Type'] ?? 'application/json';
          } else {
            options.headers.remove('Content-Type');
          }
          if (kDebugMode) {
            final hasAuth = token != null && token.isNotEmpty;
            debugPrint(
              '[API] ${options.method} ${options.baseUrl}${options.path} auth=${hasAuth ? "yes" : "NO"}',
            );
          }
          handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            debugPrint(
              '[API OK] ${response.statusCode} ${response.requestOptions.path}',
            );
          }
          handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            debugPrint(
              '[API ERROR] type=${error.type} status=${error.response?.statusCode} msg=${error.message}',
            );
            debugPrint('[API ERROR CAUSE] ${error.error}');
            debugPrint('[API ERROR BODY] ${error.response?.data}');
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();

  late final Dio _dio;

  Dio get dio => _dio;

  Future<Response<dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(() => _dio.get(path, queryParameters: queryParameters));
  }

  Future<Response<dynamic>> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.post(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Response<dynamic>> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.put(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Response<dynamic>> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.patch(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _request(
      () => _dio.delete(path, data: data, queryParameters: queryParameters),
    );
  }

  Future<Response<dynamic>> _request(
    Future<Response<dynamic>> Function() call,
  ) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (_shouldRetry(e)) {
        await Future<void>.delayed(const Duration(seconds: 1));
        try {
          return await call();
        } on DioException catch (retryError) {
          throw ApiException.fromDio(retryError);
        }
      }
      throw ApiException.fromDio(e);
    }
  }

  bool _shouldRetry(DioException error) {
    // Retry only transient gateway blips — never connection timeouts
    // (wrong host / backend down would double the wait).
    final code = error.response?.statusCode;
    return code == 502 || code == 503;
  }
}
