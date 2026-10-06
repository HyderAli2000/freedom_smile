import 'package:freedom_smile/core/storage/app_storage.dart';
import 'package:freedom_smile/create_profile.dart';
import 'package:freedom_smile/data/models/api_models.dart';
import 'package:freedom_smile/navbar.dart';
import 'package:freedom_smile/otp_verification_screen.dart';
import 'package:get/get.dart';

/// Shared post-login / post-OTP navigation.
class AuthNavigation {
  AuthNavigation._();

  static Future<void> afterAuthResult(
    ApiResult result, {
    required String email,
  }) async {
    final message = result.message.toLowerCase();
    final user = result.user;
    final hasToken = result.token != null && result.token!.isNotEmpty;

    if (message.contains('not verified') ||
        (user?.isVerified == false && !hasToken)) {
      Get.to(
        () => OtpVerificationScreen(email: email, isForgotPassword: false),
      );
      return;
    }

    // Prefer server flag. Only force create-profile when backend says incomplete.
    final completed = user?.isProfileCompleted == true;
    final incomplete = message.contains('complete your profile') ||
        user?.isProfileCompleted == false;

    if (completed) {
      await AppStorage.setProfileComplete(true);
      Get.offAll(() => const Navbar());
      return;
    }

    if (incomplete || (hasToken && !AppStorage.isProfileComplete)) {
      await AppStorage.setProfileComplete(false);
      Get.offAll(
        () => CreateProfileScreen(prefillEmail: email, isEdit: false),
      );
      return;
    }

    Get.offAll(() => const Navbar());
  }
}
