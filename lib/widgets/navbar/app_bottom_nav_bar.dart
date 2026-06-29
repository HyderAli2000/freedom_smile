import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    this.label,
    this.icon,
    this.isCenterAction = false,
  });

  final String? label;
  final IconData? icon;
  final bool isCenterAction;

  const AppBottomNavItem.centerAction()
      : label = null,
        icon = null,
        isCenterAction = true;
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  }) : assert(items.length == 5, 'Navbar expects exactly 5 items including center action');

  final int currentIndex;
  final List<AppBottomNavItem> items;
  final ValueChanged<int> onTap;

  static const _centerIndex = 2;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
        child: SizedBox(
          height: 88.h,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 72.h,
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColor.whiteColor,
                  borderRadius: BorderRadius.circular(999999.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            item: items[0],
                            selected: currentIndex == 0,
                            onTap: () => onTap(0),
                          ),
                          _NavItem(
                            item: items[1],
                            selected: currentIndex == 1,
                            onTap: () => onTap(1),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 64.w),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _NavItem(
                            item: items[3],
                            selected: currentIndex == 3,
                            onTap: () => onTap(3),
                          ),
                          _NavItem(
                            item: items[4],
                            selected: currentIndex == 4,
                            onTap: () => onTap(4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                child: GestureDetector(
                  onTap: () => onTap(_centerIndex),
                  child: Container(
                    width: 56.w,
                    height: 56.w,
                    decoration: BoxDecoration(
                      color: AppColor.blackColor,
                      shape: BoxShape.circle,
                      border: currentIndex == _centerIndex
                          ? Border.all(color: AppColor.primaryBlue, width: 2.5)
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.add_rounded,
                      color: AppColor.whiteColor,
                      size: 30.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColor.primaryBlue : AppColor.tabInactive;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(item.icon, color: color, size: 24.sp),
            4.verticalSpace,
            Text(
              item.label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
