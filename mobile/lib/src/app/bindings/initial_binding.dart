import 'package:get/get.dart';

import '../../core/controllers/locale_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LocaleController());
  }
}
