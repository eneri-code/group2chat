import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/group_controller.dart';
import '../services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize local notifications
  await NotificationService.init();

  // Initialize controllers
  Get.put(AuthController(), permanent: true);
  Get.lazyPut(() => ChatController());
  Get.lazyPut(() => GroupController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Chatify',
      debugShowCheckedModeBanner: false,

      // Themes
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      // Root widget handles login state
      home: const Root(),

      // GetX routes
      getPages: AppRoutes.routes,
      defaultTransition: Transition.fade,
    );
  }
}

/// Root widget to decide which screen to show based on login
class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Obx(() {
      // Firebase is still initializing or checking login
      if (authController.firebaseUser.value == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // User is logged in
      if (authController.firebaseUser.value != null) {
        return GetPageRouteWrapper(AppRoutes.home);
      }

      // User is NOT logged in
      return GetPageRouteWrapper(AppRoutes.login);
    });
  }
}

/// Helper to navigate using GetX routes
class GetPageRouteWrapper extends StatelessWidget {
  final String routeName;
  const GetPageRouteWrapper(this.routeName, {super.key});

  @override
  Widget build(BuildContext context) {
    // Use Future.microtask to push route after build
    Future.microtask(() => Get.offAllNamed(routeName));
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
