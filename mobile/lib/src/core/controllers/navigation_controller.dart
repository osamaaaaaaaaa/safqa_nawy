import 'package:get/get.dart';

class NavigationController extends GetxController {
  final RxInt selectedIndex = 1.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
