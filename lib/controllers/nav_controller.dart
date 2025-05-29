// lib/controllers/nav_controller.dart
import 'package:get/get.dart';

class NavController extends GetxController {
  var selectedIndex = 0.obs;

  void changePage(int index) {
    selectedIndex.value = index;
  }
}
