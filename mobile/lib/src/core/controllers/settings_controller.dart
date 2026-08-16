import 'package:get/get.dart';

class SettingsController extends GetxController {
  final RxBool clientMode = false.obs;

  void toggleClientMode() {
    clientMode.value = !clientMode.value;
  }
}
