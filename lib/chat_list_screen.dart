import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/chat_detail_screen.dart';
import 'package:freedom_smile/data/chat_list_data.dart';
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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChatListItem> get _filteredChats {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return ChatListData.items;
    return ChatListData.items
        .where(
          (chat) =>
              chat.name.toLowerCase().contains(query) ||
              chat.lastMessage.toLowerCase().contains(query),
        )
        .toList();
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
                const PageHeader(title: 'Chat', whiteBackButton: true),
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
                    hintText: 'Search',
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
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    itemCount: _filteredChats.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: 76.w,
                      color: AppColor.blackColor.withValues(alpha: 0.1),
                    ),
                    itemBuilder: (context, index) {
                      final chat = _filteredChats[index];
                      return _ChatListTile(
                        chat: chat,
                        onTap: () => Get.to(
                          () => ChatDetailScreen(
                            doctorName: chat.name,
                            avatarAsset: chat.avatarAsset,
                          ),
                        ),
                      );
                    },
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
                backgroundImage: AssetImage(chat.avatarAsset),
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
