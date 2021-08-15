import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'data/controllers/theme_controller.dart';
import 'data/controllers/user_controller.dart';
import 'data/providers/cache_provider.dart';
import 'screens/users_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'core/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  await CacheProvider.init(); // Initialize SharedPreferences
  Get.put(ThemeController()); // Initialize ThemeController
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: Get.find<ThemeController>().themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState status) {
    var controller = Get.find<UserController>();
    if (status == AppLifecycleState.resumed) {
      // Online
      controller.updateUserStatus(isActive: true);
    } else {
      // Offline
      controller.updateUserStatus(isActive: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        }
        if (snapshot.hasData) {
          return UsersScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
