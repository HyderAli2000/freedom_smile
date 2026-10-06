import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/chat_detail_screen.dart';
import 'package:freedom_smile/chat_support_screen.dart';
import 'package:freedom_smile/core/api/api_exception.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/core/utils/api_snackbar.dart';
import 'package:freedom_smile/data/chat_list_data.dart';
import 'package:freedom_smile/data/services/user_service.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _service = UserService();
  final _searchController = TextEditingController();
  bool _loading = true;
  List<ChatListItem> _chats = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final result = await _service.listChats();
      final rows = ApiMap.mapList(result.data, 'chats');
      if (rows.isEmpty && result.data is List) {
        _chats = ApiMap.mapList(result.data).map(_mapChat).toList();
      } else {
        _chats = rows.map(_mapChat).toList();
      }
    } on ApiException catch (e) {
      ApiSnackbar.fromException(e);
    } catch (_) {
      ApiSnackbar.error('Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  ChatListItem _mapChat(Map<String, dynamic> map) {
    final ortho = ApiMap.map(map['orthodontist'] ?? map['participant']);
    final type = ApiMap.str(map['type']).toLowerCase();
    final name = type == 'support'
        ? 'chat_clinic_support'.tr
        : ApiMap.str(
            ortho['name'] ?? map['name'] ?? map['title'],
            'Chat',
          );
    final last = map['lastMessage'];
    String lastText = '';
    if (last is Map) {
      lastText = ApiMap.str(last['text'] ?? last['body'] ?? last['message']);
    } else {
      lastText = ApiMap.str(map['lastMessage'] ?? map['preview']);
    }
    final timeRaw = map['updatedAt'] ??
        map['lastMessageAt'] ??
        (last is Map ? last['createdAt'] : null);
    return ChatListItem(
      id: ApiMap.id(map),
      name: name,
      lastMessage: lastText,
      time: ApiMap.relativeTime(timeRaw),
      avatarAsset: ApiMap.imageOrFallback(
        ortho['profilePicture'] ?? map['profilePicture'],
      ),
      type: type,
    );
  }

  List<ChatListItem> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _chats;
    return _chats
        .where(
          (chat) =>
              chat.name.toLowerCase().contains(query) ||
              chat.lastMessage.toLowerCase().contains(query),
        )
        .toList();
  }

  void _openChat(ChatListItem chat) {
    if (chat.type == 'support') {
      Get.to(() => ChatSupportScreen(chatId: chat.id));
      return;
    }
    Get.to(
      () => ChatDetailScreen(
        doctorName: chat.name,
        avatarAsset: chat.avatarAsset,
      ),
    );
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
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(title: 'chat'.tr, whiteBackButton: true),
                20.verticalSpace,
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontFamilyFallback: AppFonts.fallback,
                    fontSize: 14.sp,
                    color: AppColor.textDark,
                  ),
                  decoration: InputDecoration(
                    hintText: 'search'.tr,
                    hintStyle: TextStyle(
                      fontFamily: AppFonts.family,
                      fontFamilyFallback: AppFonts.fallback,
                      fontSize: 14.sp,
                      color: AppColor.primaryBlue,
                    ),
                    filled: true,
                    fillColor: AppColor.borderLightBlue.withValues(alpha: 0.5),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColor.textBody,
                      size: 22.sp,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 14.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999.r),
                      borderSide: BorderSide(
                        color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999.r),
                      borderSide: BorderSide(
                        color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(999.r),
                      borderSide: BorderSide(
                        color: AppColor.primaryBlue.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                ),
                16.verticalSpace,
                Expanded(
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: _load,
                          child: _filteredChats.isEmpty
                              ? ListView(
                                  children: [
                                    SizedBox(height: 80.h),
                                    Center(
                                      child: Text(
                                        'No chats yet',
                                        style: TextStyle(
                                          fontFamily: AppFonts.family,
                                          fontFamilyFallback:
                                              AppFonts.fallback,
                                          fontSize: 14.sp,
                                          color: AppColor.textBody,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  itemCount: _filteredChats.length,
                                  separatorBuilder: (_, __) => Divider(
                                    height: 1,
                                    indent: 76.w,
                                    color: AppColor.blackColor
                                        .withValues(alpha: 0.1),
                                  ),
                                  itemBuilder: (context, index) {
                                    final chat = _filteredChats[index];
                                    return _ChatListTile(
                                      chat: chat,
                                      onTap: () => _openChat(chat),
                                    );
                                  },
                                ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatListTile extends StatelessWidget {
  const _ChatListTile({required this.chat, required this.onTap});

  final ChatListItem chat;
  final VoidCallback onTap;

  ImageProvider _avatar() {
    final src = chat.avatarAsset;
    final network = ApiMap.resolveMediaUrl(src);
    if (network != null) return NetworkImage(network);
    return AssetImage(src);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundImage: _avatar(),
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.name,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColor.textDark,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      chat.lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontFamilyFallback: AppFonts.fallback,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColor.textBody,
                      ),
                    ),
                  ],
                ),
              ),
              8.horizontalSpace,
              Text(
                chat.time,
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontFamilyFallback: AppFonts.fallback,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColor.textBody,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
