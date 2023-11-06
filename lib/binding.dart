import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController());
    // Get.put(ScreenController());
  }
}
