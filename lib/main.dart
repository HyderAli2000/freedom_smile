import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/controllers/locale_controller.dart';
import 'package:freedom_smile/localization/app_translations.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(LocaleController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = Get.find<LocaleController>();

    return GetBuilder<LocaleController>(
      init: localeController,
      builder: (controller) {
        return GetMaterialApp(
          title: 'Freedom Smile',
          transitionDuration: const Duration(milliseconds: 500),
          defaultTransition: Transition.cupertino,
          translations: AppTranslations(),
          locale: controller.locale,
          fallbackLocale: const Locale('en', 'US'),
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: AppFonts.family,
            fontFamilyFallback: AppFonts.fallback,
            bottomSheetTheme: const BottomSheetThemeData(
              modalBackgroundColor: Colors.transparent,
              modalBarrierColor: Colors.transparent,
              modalElevation: 0,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
            appBarTheme: const AppBarTheme(surfaceTintColor: Colors.transparent),
            useMaterial3: true,
          ),
          home: ScreenUtilInit(
            designSize: const Size(430, 932),
            useInheritedMediaQuery: true,
            builder: (context, child) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: const TextScaler.linear(1.01),
                    ),
                    child: const SafeArea(
                      top: false,
                      bottom: true,
                      left: true,
                      right: true,
                      child: SplashScreen(),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
