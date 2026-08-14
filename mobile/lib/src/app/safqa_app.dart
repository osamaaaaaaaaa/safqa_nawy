import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/config/app_constants.dart';
import '../core/localization/app_translations.dart';
import '../core/theme/app_theme.dart';
import '../features/home/presentation/pages/home_page.dart';
import 'bindings/initial_binding.dart';

class SafqaApp extends StatelessWidget {
  const SafqaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.light(),
      translations: AppTranslations(),
      locale: const Locale('ar'),
      fallbackLocale: const Locale('en'),
      initialBinding: InitialBinding(),
      home: const HomePage(),
    );
  }
}
