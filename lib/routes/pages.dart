import 'package:get/get.dart';
import '/screens/auth_screen.dart';
//import '/screens/chat_screen.dart';
import '/screens/users_screen.dart';
import '/main.dart';
import 'routes.dart';

class AppPages {

  static final routes = [
    GetPage(
      name: AppRoutes.HOME, 
      page: () => HomePage(),
    ),
    GetPage(
      name: AppRoutes.AUTH, 
      page: () => AuthScreen(),
    ),
    GetPage(
      name: AppRoutes.USER, 
      page: () => UsersScreen(),
    ),
    // GetPage(
    //   name: AppRoutes.CHAT,
    //   page: () => ChatScreen(),
    // )
  ];

}