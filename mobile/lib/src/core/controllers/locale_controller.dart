import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class LocaleController extends GetxController {
  final Rx<Locale> currentLocale = const Locale('ar').obs;

  bool get isArabic => currentLocale.value.languageCode == 'ar';

  String get languageButtonLabel => isArabic ? 'EN' : 'AR';

  void toggleLocale() {
    final nextLocale = isArabic ? const Locale('en') : const Locale('ar');
    currentLocale.value = nextLocale;
    Get.updateLocale(nextLocale);
  }
}
