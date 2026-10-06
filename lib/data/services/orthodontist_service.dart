import 'package:freedom_smile/core/api/api_client.dart';
import 'package:freedom_smile/core/api/api_endpoints.dart';
import 'package:freedom_smile/core/api/api_response_parser.dart';
import 'package:freedom_smile/core/api/multipart_helper.dart';
import 'package:freedom_smile/data/models/api_models.dart';

class OrthodontistService {
  OrthodontistService({ApiClient? client})
      : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<ApiResult> myClinic() async {
    final res = await _client.get(ApiEndpoints.orthoProfile);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateClinic(
    Map<String, dynamic> body, {
    String? profilePicturePath,
  }) async {
    final data = await MultipartHelper.profilePayload(
      body,
      profilePicturePath: profilePicturePath,
    );
    final res = await _client.put(ApiEndpoints.orthoProfile, data: data);
    return _parse(res.data, 'Clinic updated');
  }

  Future<ApiResult> clinicAppointments({String? status}) async {
    final res = await _client.get(
      ApiEndpoints.orthoAppointments,
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateAppointmentStatus(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res = await _client.put(ApiEndpoints.orthoAppointment(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> listChats() async {
    final res = await _client.get(ApiEndpoints.orthoChats);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getChat(String id) async {
    final res = await _client.get(ApiEndpoints.orthoChat(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listMessages(String chatId) async {
    final res = await _client.get(ApiEndpoints.orthoChatMessages(chatId));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> sendMessage(String chatId, String text) async {
    final res = await _client.post(
      ApiEndpoints.orthoChatMessages(chatId),
      data: {'text': text},
    );
    return _parse(res.data, 'Message sent');
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
