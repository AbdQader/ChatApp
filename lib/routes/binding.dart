import 'package:get/get.dart';
import '/data/controllers/auth_controller.dart';
import '/data/controllers/user_controller.dart';
import '/data/controllers/chat_controller.dart';

class AppBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
