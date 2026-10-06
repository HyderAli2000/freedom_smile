import 'package:freedom_smile/core/api/api_client.dart';
import 'package:freedom_smile/core/api/api_endpoints.dart';
import 'package:freedom_smile/core/api/api_response_parser.dart';
import 'package:freedom_smile/data/models/api_models.dart';

class ContentService {
  ContentService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<ApiResult> listFaqs() async {
    final res = await _client.get(ApiEndpoints.faqs);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listLanguages() async {
    final res = await _client.get(ApiEndpoints.languages);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listRewardTiers() async {
    final res = await _client.get(ApiEndpoints.rewardTiers);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getCms(String slug) async {
    final res = await _client.get(ApiEndpoints.cms(slug));
    return _parse(res.data, 'OK');
  }

  ApiResult _parse(dynamic data, String fallback) {
    final root = ApiResponseParser.asMap(data);
    return ApiResult(
      message: ApiResponseParser.message(data, fallback),
      data: root['data'],
      raw: root,
    );
  }
}
