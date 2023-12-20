import 'package:get/get.dart';
import 'package:medico/controllers/auth_controller.dart';
import 'package:medico/controllers/feed_controller.dart';
import 'package:medico/controllers/search_controller.dart';

import 'controllers/db_controller.dart';
import 'controllers/screen_controller.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthenticationController());
    Get.put(ScreenController());
    Get.put(DbController());
    Get.lazyPut(() => FeedController(), fenix: true);
    Get.lazyPut(() => UserSearchController(), fenix: true);
  }
}
