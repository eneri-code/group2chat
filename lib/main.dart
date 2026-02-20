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

  // Initialize Firebase safely
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase init error: $e");
  }

  // Initialize notifications safely
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint("Notification init error: $e");
  }

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

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      home: const Root(),

      getPages: AppRoutes.routes,
      defaultTransition: Transition.fade,
    );
  }
}

/// Root widget decides navigation based on auth readiness
class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();

    // Wait until Firebase auth check completes
    ever(authController.isAuthReady, (ready) {
      if (ready == true) {
        _routeUser();
      }
    });
  }

  void _routeUser() {
    final user = authController.firebaseUser.value;

    if (user != null) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
