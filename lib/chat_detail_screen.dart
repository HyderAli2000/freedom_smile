import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:get/get.dart';

enum _ChatSender { doctor, user }

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

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({
    super.key,
    required this.doctorName,
    required this.avatarAsset,
  });

  final String doctorName;
  final String avatarAsset;

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  static const _emergencyRed = Color(0xFFE53935);

  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isEmergencyMode = false;

  final List<_ChatMessage> _messages = const [
    _ChatMessage(
      sender: _ChatSender.doctor,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      time: '3:00 pm',
    ),
    _ChatMessage(
      sender: _ChatSender.user,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      time: '3:00 pm',
    ),
    _ChatMessage(
      sender: _ChatSender.doctor,
      text:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      time: '3:00 pm',
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleEmergencyMode() {
    setState(() => _isEmergencyMode = !_isEmergencyMode);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(
        _ChatMessage(sender: _ChatSender.user, text: text, time: '3:00 pm'),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _isEmergencyMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: _isEmergencyMode ? _emergencyRed : AppColor.whiteColor,
        body: SafeArea(
          child: Container(
            decoration: _isEmergencyMode
                ? const BoxDecoration(color: _emergencyRed)
                : BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AssetImages.bgOthers),
                      fit: BoxFit.cover,
                    ),
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ChatDetailHeader(
                  doctorName: widget.doctorName,
                  isEmergencyMode: _isEmergencyMode,
                  onWarningTap: _toggleEmergencyMode,
                ),
                Expanded(
                  child: ListView.separated(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
                    itemCount: _messages.length,
                    separatorBuilder: (_, __) => 16.verticalSpace,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return message.sender == _ChatSender.doctor
                          ? _DoctorMessageBubble(
                              message: message,
                              avatarAsset: widget.avatarAsset,
                              isEmergencyMode: _isEmergencyMode,
                            )
                          : _UserMessageBubble(
                              message: message,
                              isEmergencyMode: _isEmergencyMode,
                            );
                    },
                  ),
                ),
                Divider(
                  height: 1,
                  color: _isEmergencyMode
                      ? AppColor.whiteColor.withValues(alpha: 0.85)
                      : AppColor.blackColor.withValues(alpha: 0.1),
                ),
                _ChatInputBar(
                  controller: _messageController,
                  onSend: _sendMessage,
                  isEmergencyMode: _isEmergencyMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatDetailHeader extends StatelessWidget {
  const _ChatDetailHeader({
    required this.doctorName,
    required this.isEmergencyMode,
    required this.onWarningTap,
  });

  final String doctorName;
  final bool isEmergencyMode;
  final VoidCallback onWarningTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = isEmergencyMode
        ? AppColor.whiteColor
        : AppColor.textDark;

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
                color: AppColor.whiteColor,
                border: isEmergencyMode
                    ? null
                    : Border.all(color: AppColor.primaryBlue, width: 1.5),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColor.primaryBlue,
                size: 26.sp,
              ),
            ),
          ),
          12.horizontalSpace,
          Expanded(
            child: Text(
              doctorName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontFamilyFallback: AppFonts.fallback,
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: titleColor,
              ),
            ),
          ),
          isEmergencyMode
              ? SizedBox.shrink()
              : GestureDetector(
                  onTap: onWarningTap,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isEmergencyMode
                          ? AppColor.whiteColor.withValues(alpha: 0.2)
                          : AppColor.whiteColor.withValues(alpha: 0.92),
                      border: isEmergencyMode
                          ? Border.all(
                              color: AppColor.whiteColor.withValues(alpha: 0.6),
                            )
                          : Border.all(color: AppColor.primaryBlue, width: 1.5),
                    ),
                    child: Icon(
                      Icons.warning_rounded,
                      color: isEmergencyMode
                          ? AppColor.whiteColor
                          : Colors.red.shade400,
                      size: 26.sp,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _DoctorMessageBubble extends StatelessWidget {
  const _DoctorMessageBubble({
    required this.message,
    required this.avatarAsset,
    required this.isEmergencyMode,
  });

  final _ChatMessage message;
  final String avatarAsset;
  final bool isEmergencyMode;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isEmergencyMode
        ? AppColor.whiteColor
        : AppColor.profileOptionBg.withValues(alpha: 0.95);
    final textColor = isEmergencyMode ? AppColor.textDark : AppColor.textDark;
    final timeColor = isEmergencyMode ? AppColor.whiteColor : AppColor.textBody;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CircleAvatar(
              radius: 18.r,
              backgroundImage: AssetImage(avatarAsset),
            ),
            8.horizontalSpace,
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                  ),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
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
              color: timeColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _UserMessageBubble extends StatelessWidget {
  const _UserMessageBubble({
    required this.message,
    required this.isEmergencyMode,
  });

  final _ChatMessage message;
  final bool isEmergencyMode;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isEmergencyMode
        ? const Color(0xFFB71C1C).withValues(alpha: 0.55)
        : AppColor.primaryBlue;
    final timeColor = isEmergencyMode ? AppColor.whiteColor : AppColor.textBody;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    topRight: Radius.circular(4.r),
                    bottomLeft: Radius.circular(16.r),
                    bottomRight: Radius.circular(16.r),
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
            8.horizontalSpace,
            CircleAvatar(
              radius: 18.r,
              backgroundImage: AssetImage(AssetImages.p1),
            ),
          ],
        ),
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
              color: timeColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  const _ChatInputBar({
    required this.controller,
    required this.onSend,
    required this.isEmergencyMode,
  });

  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isEmergencyMode;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 12.h),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundImage: AssetImage(AssetImages.p1),
          ),
          10.horizontalSpace,
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: 'Write your message..',
                hintStyle: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 14.sp,
                  color: AppColor.textBody.withValues(alpha: 0.7),
                ),
                filled: true,
                fillColor: AppColor.whiteColor,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 18.w,
                  vertical: 12.h,
                ),
                suffixIcon: isEmergencyMode
                    ? Icon(
                        Icons.attach_file_rounded,
                        color: AppColor.primaryBlue,
                        size: 22.sp,
                      )
                    : null,
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
