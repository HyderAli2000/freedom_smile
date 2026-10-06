import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freedom_smile/core/utils/api_map.dart';
import 'package:freedom_smile/utils/assets_images.dart';

/// Renders a network URL, local file path, or asset fallback.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    this.source,
    this.fallbackAsset = AssetImages.p1,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String? source;
  final String fallbackAsset;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final resolved = ApiMap.resolveMediaUrl(source);
    if (resolved != null) {
      return Image.network(
        resolved,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Image.asset(
          fallbackAsset,
          fit: fit,
          width: width,
          height: height,
        ),
      );
    }

    final local = source?.trim() ?? '';
    if (local.isNotEmpty &&
        !local.startsWith('assets/') &&
        File(local).existsSync()) {
      return Image.file(
        File(local),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => Image.asset(
          fallbackAsset,
          fit: fit,
          width: width,
          height: height,
        ),
      );
    }

    final asset = (local.startsWith('assets/') || local.isEmpty)
        ? (local.isEmpty ? fallbackAsset : local)
        : fallbackAsset;
    return Image.asset(asset, fit: fit, width: width, height: height);
  }
}

class AppCircleAvatar extends StatelessWidget {
  const AppCircleAvatar({
    super.key,
    this.source,
    this.radius = 24,
    this.fallbackAsset = AssetImages.p1,
    this.backgroundColor,
  });

  final String? source;
  final double radius;
  final String fallbackAsset;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? Colors.grey.shade200,
      child: ClipOval(
        child: SizedBox(
          width: radius * 2,
          height: radius * 2,
          child: AppNetworkImage(
            source: source,
            fallbackAsset: fallbackAsset,
          ),
        ),
      ),
    );
  }
}
