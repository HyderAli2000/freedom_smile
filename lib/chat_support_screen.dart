import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/faqs_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/app_network_image.dart';
import 'package:get/get.dart';

enum _ChatSender { support, user }

class _ChatMessage {
  const _ChatMessage({
    required this.sender,
    required this.text,
    required this.time,
  });

  final _ChatSender sender;
  final String text;
  final String time;
}

class ChatSupportScreen extends StatefulWidget {
  const ChatSupportScreen({super.key, this.chatId});

  final String? chatId;

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final _service = UserService();
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  bool _loading = true;
  bool _sending = false;
  String? _chatId;
  List<_ChatMessage> _messages = const [];

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;
    _bootstrap();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() => _loading = true);
    try {
      if (_chatId == null || _chatId!.isEmpty) {
        final opened = await _service.openChat(type: 'support');
        final data = ApiMap.map(opened.data);
        final chat = ApiMap.map(data['chat']);
        _chatId = ApiMap.id(chat.isNotEmpty ? chat : data);
        if (_chatId!.isEmpty) {
          _chatId = ApiMap.str(data['chatId'] ?? data['_id'] ?? data['id']);
        }
      }
      if (_chatId != null && _chatId!.isNotEmpty) {
        await _loadMessages();
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMessages() async {
    final id = _chatId;
    if (id == null || id.isEmpty) return;
    final result = await _service.listMessages(id);
    final rows = ApiMap.mapList(result.data, 'messages');
    _messages = rows.map(_mapMessage).toList();
    _scrollToEnd();
  }

  _ChatMessage _mapMessage(Map<String, dynamic> map) {
    final role = ApiMap.str(
      map['senderRole'] ??
          map['senderType'] ??
          map['role'] ??
          map['from'] ??
          (map['sender'] is Map
              ? (map['sender']['userType'] ?? map['sender']['role'])
              : map['sender']),
    ).toLowerCase();

    final isSupport = role.contains('support') ||
        role.contains('admin') ||
        role.contains('bot') ||
        role.contains('system');
    final isMine = ApiMap.boolVal(map['isMine'] ?? map['fromMe']);
    final isUser = !isSupport &&
        (isMine ||
            role.contains('user') ||
            role.isEmpty ||
            ApiMap.str(map['sender']) == (AppStorage.userId ?? ''));

    final text = ApiMap.str(map['text'] ?? map['body'] ?? map['message']);
    final time = ApiMap.relativeTime(map['createdAt'] ?? map['time']);
    return _ChatMessage(
      sender: isUser ? _ChatSender.user : _ChatSender.support,
      text: text,
      time: time.isEmpty ? '' : time,
    );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _sending) return;
    final id = _chatId;
    if (id == null || id.isEmpty) {
      ApiSnackbar.error('Chat is not ready yet');
      return;
    }

    setState(() => _sending = true);
    _messageController.clear();
    setState(() {
      _messages = [
        ..._messages,
        _ChatMessage(
          sender: _ChatSender.user,
          text: text,
          time: 'Just now',
        ),
      ];
    });
    _scrollToEnd();

    try {
      await _service.sendMessage(id, text);
      await _loadMessages();
      if (mounted) setState(() {});
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AssetImages.bgOthers),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ChatSupportHeader(
                onFaqTap: () => Get.to(() => const FaqsScreen()),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        controller: _scrollController,
                        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                        itemCount: _messages.length,
                        separatorBuilder: (_, __) => 14.verticalSpace,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          return message.sender == _ChatSender.support
                              ? _SupportMessageBubble(message: message)
                              : _UserMessageBubble(message: message);
                        },
                      ),
              ),
              _ChatInputBar(
                controller: _messageController,
                onSend: _sendMessage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatSupportHeader extends StatelessWidget {
  const _ChatSupportHeader({required this.onFaqTap});

  final VoidCallback onFaqTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.whiteColor.withValues(alpha: 0.92),
                border: Border.all(color: AppColor.primaryBlue, width: 1.5),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColor.primaryBlue,
                size: 26.sp,
              ),
            ),
          ),
          12.horizontalSpace,
          Container(
            width: 40.w,
            height: 40.w,
            padding: EdgeInsets.all(5.w),
            decoration: const BoxDecoration(
              color: AppColor.primaryBlue,
              shape: BoxShape.circle,
            ),
            child: Image.asset(
              AssetIcons.robo,
              fit: BoxFit.contain,
              color: AppColor.whiteColor,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              'chat_support'.tr,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: AppColor.textDark,
              ),
            ),
          ),
          GestureDetector(
            onTap: onFaqTap,
            child: Text(
              'faqs_short'.tr,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: AppColor.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportMessageBubble extends StatelessWidget {
  const _SupportMessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: AppColor.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    AssetIcons.robo,
                    fit: BoxFit.contain,
                    color: AppColor.whiteColor,
                  ),
                ),
                8.horizontalSpace,
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColor.primaryBlue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.whiteColor,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (message.time.isNotEmpty) ...[
              6.verticalSpace,
              Padding(
                padding: EdgeInsets.only(left: 44.w),
                child: Text(
                  message.time,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textBody,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.78.sw),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColor.profileOptionBg,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                        bottomLeft: Radius.circular(16.r),
                        bottomRight: Radius.circular(4.r),
                      ),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                8.horizontalSpace,
                AppCircleAvatar(
                  radius: 18.r,
                  source: AppStorage.profilePicture,
                  backgroundColor: AppColor.profileOptionBg,
                ),
              ],
            ),
            if (message.time.isNotEmpty) ...[
              6.verticalSpace,
              Padding(
                padding: EdgeInsets.only(right: 44.w),
                child: Text(
                  message.time,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColor.textBody,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Row(
        children: [
          AppCircleAvatar(
            radius: 20.r,
            source: AppStorage.profilePicture,
            backgroundColor: AppColor.profileOptionBg,
          ),
          10.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'write_your_message'.tr,
                hintStyle: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColor.textBody.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppColor.whiteColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 12.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999.r),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(999.r),
                  borderSide: BorderSide(
                    color: AppColor.primaryBlue.withValues(alpha: 0.35),
                  ),
                ),
              ),
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColor.textDark,
              ),
            ),
          ),
          10.horizontalSpace,
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 44.w,
              height: 44.w,
              padding: EdgeInsets.all(10.w),
              decoration: const BoxDecoration(
                color: AppColor.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                AssetIcons.send,
                fit: BoxFit.contain,
                color: AppColor.whiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
