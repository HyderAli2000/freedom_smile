import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';

class AppBottomNavItem {
  const AppBottomNavItem({this.label, this.icon, this.isCenterAction = false});

  final String? label;
  final String? icon;
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
  }) : assert(
         items.length == 5,
         'Navbar expects exactly 5 items including center action',
       );

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
          height: 96.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 76.h,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    SizedBox(width: 56.w),
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
        height: 64.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.h,
              child: selected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 20.w,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: AppColor.primaryBlue,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(6.r),
                              bottomRight: Radius.circular(6.r),
                            ),
                          ),
                        ),
                        2.verticalSpace,
                        Container(
                          width: 6.w,
                          height: 6.w,
                          decoration: const BoxDecoration(
                            color: AppColor.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
            10.verticalSpace,
            Image.asset(
              item.icon ?? '',
              color: color,
              width: 22.w,
              height: 22.h,
            ),
            3.verticalSpace,
            Text(
              item.label ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: color,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
