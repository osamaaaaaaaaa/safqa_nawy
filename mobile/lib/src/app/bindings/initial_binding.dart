import 'package:get/get.dart';

import '../../core/controllers/locale_controller.dart';
import '../../core/controllers/navigation_controller.dart';
import '../../core/controllers/settings_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocaleController());
    Get.put(NavigationController());
    Get.put(SettingsController());
  }
}
