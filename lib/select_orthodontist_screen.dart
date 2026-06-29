import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_colors.dart';
import 'package:freedom_smile/utils/assets_icons.dart';
import 'package:freedom_smile/widgets/common/page_header.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class SelectOrthodontistScreen extends StatelessWidget {
  const SelectOrthodontistScreen({super.key});

  static const _center = LatLng(40.758, -73.9855);

  static const _markerLocations = [
    LatLng(40.7614, -73.9776),
    LatLng(40.7505, -73.9934),
    LatLng(40.7549, -73.9840),
    LatLng(40.7658, -73.9726),
    LatLng(40.7484, -73.9857),
    LatLng(40.7590, -73.9695),
    LatLng(40.7520, -73.9770),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _center,
              initialZoom: 13.2,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.freedom_smile.app',
                tileProvider: NetworkTileProvider(
                  cachingProvider: DisabledMapCachingProvider(),
                ),
              ),
              MarkerLayer(
                markers: _markerLocations
                    .map(
                      (location) => Marker(
                        point: location,
                        width: 44.w,
                        height: 44.w,
                        child: const _OrthodontistMapMarker(),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: AppColor.whiteColor.withValues(alpha: 0.92),
                  child: const PageHeader(
                    title: 'Select Near-by Orthodontist',
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52.h,
                    child: ElevatedButton(
                      onPressed: Get.back,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryBlue,
                        foregroundColor: AppColor.whiteColor,
                        elevation: 4,
                        shadowColor: Colors.black.withValues(alpha: 0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColor.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrthodontistMapMarker extends StatelessWidget {
  const _OrthodontistMapMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primaryBlue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.all(10.w),
      child: Image.asset(
        AssetIcons.building,
        color: AppColor.whiteColor,
        fit: BoxFit.contain,
      ),
    );
  }
}
