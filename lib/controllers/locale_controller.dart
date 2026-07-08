import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends GetxController {
  static const _storageKey = 'app_locale_code';

  Locale locale = const Locale('en', 'US');

  bool get isSpanish => locale.languageCode == 'es';

  String get currentLanguageLabel =>
      isSpanish ? 'language_spanish'.tr : 'language_english'.tr;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_storageKey);
    if (code == 'es') {
      locale = const Locale('es', 'ES');
      Get.updateLocale(locale);
      update();
    }
  }

  Future<void> setLocaleCode(String code) async {
    locale = code == 'es'
        ? const Locale('es', 'ES')
        : const Locale('en', 'US');
    Get.updateLocale(locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, locale.languageCode);
    update();
  }
}
