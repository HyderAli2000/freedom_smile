import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/faqs_screen.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
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
  const ChatSupportScreen({super.key});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  final List<_ChatMessage> _messages = [
    _ChatMessage(
      sender: _ChatSender.user,
      text: 'support_user_message_sample'.tr,
      time: 'chat_time_3pm'.tr,
    ),
    _ChatMessage(
      sender: _ChatSender.support,
      text: 'support_reply_sample'.tr,
      time: 'chat_time_3pm'.tr,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(sender: _ChatSender.user, text: text, time: 'chat_time_3pm'.tr),
      );
      _messageController.clear();
    });

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
                child: ListView.separated(
                  controller: _scrollController,
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                  itemCount: _messages.length,
                  separatorBuilder: (_, __) => 16.verticalSpace,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
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
            8.horizontalSpace,
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.primaryBlue,
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
                    color: AppColor.whiteColor,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
        6.verticalSpace,
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Align(
            alignment: Alignment.centerRight,
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
        ),
      ],
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({required this.message});

  final _ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColor.profileOptionBg.withValues(alpha: 0.95),
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
                    color: AppColor.textDark,
                    height: 1.4,
                  ),
                ),
              ),
            ),
            8.horizontalSpace,
            CircleAvatar(
              radius: 20.r,
              backgroundImage: AssetImage(AssetImages.p1),
            ),
          ],
        ),
        6.verticalSpace,
        Padding(
          padding: EdgeInsets.only(left: 8.w),
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
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(AssetImages.p1),
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
                color: AppColor.textDark,
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
