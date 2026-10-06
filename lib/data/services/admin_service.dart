import 'package:freedom_smile/core/api/api_client.dart';
import 'package:freedom_smile/core/api/api_endpoints.dart';
import 'package:freedom_smile/core/api/api_response_parser.dart';
import 'package:freedom_smile/data/models/api_models.dart';

/// Admin panel APIs (available for future admin app / tooling).
class AdminService {
  AdminService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<ApiResult> dashboard() async {
    final res = await _client.get(ApiEndpoints.adminDashboard);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listUsers() async {
    final res = await _client.get(ApiEndpoints.adminUsers);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getUser(String id) async {
    final res = await _client.get(ApiEndpoints.adminUser(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateUser(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminUser(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> listOrthodontists() async {
    final res = await _client.get(ApiEndpoints.adminOrthodontists);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createOrthodontist(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminOrthodontists, data: body);
    return _parse(res.data, 'Created');
  }

  Future<ApiResult> updateOrthodontist(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res =
        await _client.put(ApiEndpoints.adminOrthodontist(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> deleteOrthodontist(String id) async {
    final res = await _client.delete(ApiEndpoints.adminOrthodontist(id));
    return _parse(res.data, 'Deleted');
  }

  Future<ApiResult> listAppointments() async {
    final res = await _client.get(ApiEndpoints.adminAppointments);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateAppointment(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res =
        await _client.put(ApiEndpoints.adminAppointment(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> listCategories() async {
    final res = await _client.get(ApiEndpoints.adminCategories);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createCategory(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminCategories, data: body);
    return _parse(res.data, 'Created');
  }

  Future<ApiResult> updateCategory(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminCategory(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> deleteCategory(String id) async {
    final res = await _client.delete(ApiEndpoints.adminCategory(id));
    return _parse(res.data, 'Deleted');
  }

  Future<ApiResult> listTips() async {
    final res = await _client.get(ApiEndpoints.adminTips);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createTip(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminTips, data: body);
    return _parse(res.data, 'Created');
  }

  Future<ApiResult> updateTip(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminTip(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> deleteTip(String id) async {
    final res = await _client.delete(ApiEndpoints.adminTip(id));
    return _parse(res.data, 'Deleted');
  }

  Future<ApiResult> listFaqs() async {
    final res = await _client.get(ApiEndpoints.adminFaqs);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createFaq(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminFaqs, data: body);
    return _parse(res.data, 'Created');
  }

  Future<ApiResult> updateFaq(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminFaq(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> deleteFaq(String id) async {
    final res = await _client.delete(ApiEndpoints.adminFaq(id));
    return _parse(res.data, 'Deleted');
  }

  Future<ApiResult> listCms() async {
    final res = await _client.get(ApiEndpoints.adminCms);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateCms(String slug, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminCmsSlug(slug), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> listRewards() async {
    final res = await _client.get(ApiEndpoints.adminRewards);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createReward(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminRewards, data: body);
    return _parse(res.data, 'Created');
  }

  Future<ApiResult> updateReward(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminReward(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> deleteReward(String id) async {
    final res = await _client.delete(ApiEndpoints.adminReward(id));
    return _parse(res.data, 'Deleted');
  }

  Future<ApiResult> listReferrals() async {
    final res = await _client.get(ApiEndpoints.adminReferrals);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateReferral(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.adminReferral(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> broadcast(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.adminNotifications, data: body);
    return _parse(res.data, 'Broadcast sent');
  }

  Future<ApiResult> listRetainerOrders() async {
    final res = await _client.get(ApiEndpoints.adminRetainerOrders);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateRetainerOrder(
    String id,
    Map<String, dynamic> body,
  ) async {
    final res =
        await _client.put(ApiEndpoints.adminRetainerOrder(id), data: body);
    return _parse(res.data, 'Updated');
  }

  Future<ApiResult> listChats() async {
    final res = await _client.get(ApiEndpoints.adminChats);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getChat(String id) async {
    final res = await _client.get(ApiEndpoints.adminChat(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listMessages(String chatId) async {
    final res = await _client.get(ApiEndpoints.adminChatMessages(chatId));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> sendMessage(String chatId, String text) async {
    final res = await _client.post(
      ApiEndpoints.adminChatMessages(chatId),
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
