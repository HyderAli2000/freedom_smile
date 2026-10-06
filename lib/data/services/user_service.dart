import 'package:freedom_smile/core/api/api_client.dart';
import 'package:freedom_smile/core/api/api_endpoints.dart';
import 'package:freedom_smile/core/api/api_response_parser.dart';
import 'package:freedom_smile/data/models/api_models.dart';

class UserService {
  UserService({ApiClient? client}) : _client = client ?? ApiClient.instance;

  final ApiClient _client;

  Future<ApiResult> home() async {
    final res = await _client.get(ApiEndpoints.userHome);
    return _parse(res.data, 'Home loaded');
  }

  Future<ApiResult> settings() async {
    final res = await _client.get(ApiEndpoints.userSettings);
    return _parse(res.data, 'Settings loaded');
  }

  Future<ApiResult> getRetainer() async {
    final res = await _client.get(ApiEndpoints.userRetainer);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> updateRetainer(Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.userRetainer, data: body);
    return _parse(res.data, 'Retainer updated');
  }

  Future<ApiResult> listRetainerOrders() async {
    final res = await _client.get(ApiEndpoints.userRetainerOrders);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> requestRetainerReorder() async {
    final res = await _client.post(ApiEndpoints.userRetainerReorder);
    return _parse(res.data, 'Reorder requested');
  }

  Future<ApiResult> markWorn({String action = 'start'}) async {
    final res = await _client.post(
      ApiEndpoints.userWearMark,
      data: {'action': action},
    );
    return _parse(res.data, 'Marked as worn');
  }

  Future<ApiResult> wearStats() async {
    final res = await _client.get(ApiEndpoints.userWearStats);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> saveFitCheck({
    required bool fitsComfortably,
    required bool wearsRegularly,
  }) async {
    final res = await _client.post(
      ApiEndpoints.userFitCheck,
      data: {
        'fitsComfortably': fitsComfortably,
        'wearsRegularly': wearsRegularly,
      },
    );
    return _parse(res.data, 'Fit check saved');
  }

  Future<ApiResult> listReminders() async {
    final res = await _client.get(ApiEndpoints.userReminders);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getReminder(String id) async {
    final res = await _client.get(ApiEndpoints.userReminder(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> createReminder(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.userReminders, data: body);
    return _parse(res.data, 'Reminder created');
  }

  Future<ApiResult> updateReminder(String id, Map<String, dynamic> body) async {
    final res = await _client.put(ApiEndpoints.userReminder(id), data: body);
    return _parse(res.data, 'Reminder updated');
  }

  Future<ApiResult> deleteReminder(String id) async {
    final res = await _client.delete(ApiEndpoints.userReminder(id));
    return _parse(res.data, 'Reminder deleted');
  }

  Future<ApiResult> listTipCategories() async {
    final res = await _client.get(ApiEndpoints.userTipCategories);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listTips({String? category}) async {
    final res = await _client.get(
      ApiEndpoints.userTips,
      queryParameters: {
        if (category != null && category.isNotEmpty) 'category': category,
      },
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> tipDetail(String id) async {
    final res = await _client.get(ApiEndpoints.userTip(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listOrthodontists({String? search}) async {
    final res = await _client.get(
      ApiEndpoints.userOrthodontists,
      queryParameters: {
        if (search != null && search.isNotEmpty) 'search': search,
      },
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> orthodontistDetail(String id) async {
    final res = await _client.get(ApiEndpoints.userOrthodontist(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> orthodontistSlots(String id, {String? date}) async {
    final res = await _client.get(
      ApiEndpoints.userOrthodontistSlots(id),
      queryParameters: {
        if (date != null && date.isNotEmpty) 'date': date,
      },
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listAppointments({String? status}) async {
    final res = await _client.get(
      ApiEndpoints.userAppointments,
      queryParameters: {
        if (status != null && status.isNotEmpty) 'status': status,
      },
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> bookAppointment(Map<String, dynamic> body) async {
    final res = await _client.post(ApiEndpoints.userAppointments, data: body);
    return _parse(res.data, 'Appointment booked');
  }

  Future<ApiResult> getAppointment(String id) async {
    final res = await _client.get(ApiEndpoints.userAppointment(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> cancelAppointment(String id) async {
    final res = await _client.put(ApiEndpoints.userAppointmentCancel(id));
    return _parse(res.data, 'Appointment cancelled');
  }

  Future<ApiResult> referralSummary() async {
    final res = await _client.get(ApiEndpoints.userReferrals);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> applyReferral(String code) async {
    final res = await _client.post(
      ApiEndpoints.userReferralsApply,
      data: {'code': code},
    );
    return _parse(res.data, 'Referral applied');
  }

  Future<ApiResult> listNotifications() async {
    final res = await _client.get(ApiEndpoints.userNotifications);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> getNotification(String id) async {
    final res = await _client.get(ApiEndpoints.userNotification(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> markNotificationRead(String id) async {
    final res = await _client.put(ApiEndpoints.userNotificationRead(id));
    return _parse(res.data, 'Marked as read');
  }

  Future<ApiResult> notificationAction(String id, String action) async {
    final res = await _client.post(
      ApiEndpoints.userNotificationAction(id),
      data: {'action': action},
    );
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listChats() async {
    final res = await _client.get(ApiEndpoints.userChats);
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> openChat({
    String type = 'support',
    String? orthodontistId,
  }) async {
    final res = await _client.post(
      ApiEndpoints.userChats,
      data: {
        'type': type,
        if (orthodontistId != null) 'orthodontistId': orthodontistId,
      },
    );
    return _parse(res.data, 'Chat opened');
  }

  Future<ApiResult> getChat(String id) async {
    final res = await _client.get(ApiEndpoints.userChat(id));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> listMessages(String chatId) async {
    final res = await _client.get(ApiEndpoints.userChatMessages(chatId));
    return _parse(res.data, 'OK');
  }

  Future<ApiResult> sendMessage(String chatId, String text) async {
    final res = await _client.post(
      ApiEndpoints.userChatMessages(chatId),
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
