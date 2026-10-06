import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/core/api/multipart_helper.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/utils/assets_images.dart';
import 'package:freedom_smile/widgets/common/app_network_image.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

/// Circular avatar with camera badge; picks gallery/camera and returns a local path.
class ProfileImagePicker extends StatelessWidget {
  const ProfileImagePicker({
    super.key,
    this.networkUrl,
    this.localPath,
    this.size,
    this.onChanged,
    this.lightChrome = false,
    this.showCamera = true,
    this.fallbackAsset = AssetImages.p1,
  });

  final String? networkUrl;
  final String? localPath;
  final double? size;
  final ValueChanged<String?>? onChanged;
  final bool lightChrome;
  final bool showCamera;
  final String fallbackAsset;

  Future<void> _showSourceSheet(BuildContext context) async {
    if (onChanged == null) return;

    final choice = await showModalBottomSheet<_PickAction>(
      context: context,
      backgroundColor: AppColor.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                16.verticalSpace,
                ListTile(
                  leading: Icon(Icons.photo_library_outlined,
                      color: AppColor.primaryBlue),
                  title: Text('photo_gallery'.tr),
                  onTap: () => Navigator.pop(ctx, _PickAction.gallery),
                ),
                ListTile(
                  leading:
                      Icon(Icons.photo_camera_outlined, color: AppColor.primaryBlue),
                  title: Text('photo_camera'.tr),
                  onTap: () => Navigator.pop(ctx, _PickAction.camera),
                ),
                if (localPath != null && localPath!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delete_outline, color: Colors.red),
                    title: Text('remove_photo'.tr),
                    onTap: () => Navigator.pop(ctx, _PickAction.remove),
                  ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: Text('cancel'.tr),
                  onTap: () => Navigator.pop(ctx),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (choice == null) return;
    if (choice == _PickAction.remove) {
      onChanged!(null);
      return;
    }

    final picker = ImagePicker();
    final source =
        choice == _PickAction.camera ? ImageSource.camera : ImageSource.gallery;
    final file = await picker.pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    if (file != null) onChanged!(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final avatarSize = size ?? 120.w;
    final displaySource = (localPath != null && localPath!.isNotEmpty)
        ? localPath
        : networkUrl;
    final borderColor = lightChrome
        ? AppColor.whiteColor.withValues(alpha: 0.7)
        : AppColor.primaryBlue.withValues(alpha: 0.35);

    return GestureDetector(
      onTap: onChanged == null ? null : () => _showSourceSheet(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightChrome ? AppColor.whiteColor : Colors.grey.shade200,
              border: Border.all(color: borderColor, width: lightChrome ? 5.w : 3),
            ),
            child: ClipOval(
              child: displaySource == null || displaySource.isEmpty
                  ? (lightChrome
                      ? Padding(
                          padding: EdgeInsets.all(avatarSize * 0.28),
                          child: Image.asset(
                            AssetIcons.cam,
                            color: AppColor.buttonTextClr,
                          ),
                        )
                      : AppNetworkImage(
                          source: null,
                          fallbackAsset: fallbackAsset,
                        ))
                  : AppNetworkImage(
                      source: displaySource,
                      fallbackAsset: fallbackAsset,
                    ),
            ),
          ),
          if (showCamera && onChanged != null)
            Positioned(
              right: 4.w,
              bottom: 4.h,
              child: Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: lightChrome
                        ? AppColor.primaryBlue
                        : AppColor.borderLightBlue.withValues(alpha: 0.45),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(7.w),
                child: Image.asset(
                  AssetIcons.cam,
                  color: AppColor.primaryBlue,
                  fit: BoxFit.contain,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

enum _PickAction { gallery, camera, remove }

/// Helper for callers that only need a path without a widget.
class ProfileImagePickerUtil {
  ProfileImagePickerUtil._();

  static Future<String?> pick({ImageSource source = ImageSource.gallery}) async {
    final file = await ImagePicker().pickImage(
      source: source,
      maxWidth: 1200,
      maxHeight: 1200,
      imageQuality: 85,
    );
    return file?.path;
  }

  static bool isLocalFile(String? path) => MultipartHelper.isLocalFilePath(path);
}
