import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freedom_smile/utils/app_fonts.dart';
import 'package:freedom_smile/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Freedom Smile',
      transitionDuration: const Duration(milliseconds: 500),
      defaultTransition: Transition.cupertino,
      locale: const Locale('en', 'US'),
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
        // fontFamily: GoogleFonts.inter().fontFamily,
      ),
      home: ScreenUtilInit(
        designSize: const Size(430, 932),
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              // final screenWidth = constraints.maxWidth;

              // // Agar tablet hai (jaise iPad)
              // if (screenWidth > 600) {
              //   // Adjust base design for larger screens
              //   ScreenUtil.init(
              //     context,
              //     designSize: const Size(834, 1194), // iPad Air 10.9"
              //   );
              // }
              return MediaQuery(
                data: MediaQuery.of(
                  context,
                ).copyWith(textScaler: const TextScaler.linear(1.01)),
                child: SafeArea(
                  top: false,
                  bottom: true,
                  left: true,
                  right: true,
                  child: const SplashScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
