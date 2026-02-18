import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import your files
import 'firebase_options.dart';
import 'routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/chat_controller.dart';
import 'controllers/group_controller.dart';

void main() async {
  // 1. Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 3. Inject Global Controllers (Dependency Injection)
  // These stay in memory throughout the app's lifecycle
  Get.put(AuthController(), permanent: true);
  
  // These can be lazily loaded or put here for immediate availability
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
      
      // 4. Setup Theme from your core/theme folder
      theme: AppTheme.lightTheme,
      
      // 5. Setup Routes from your routes/app_routes.dart
      initialRoute: AppRoutes.login, 
      getPages: AppRoutes.routes,
      
      // Optional: Global snackbar/dialog styling
      defaultTransition: Transition.fade,
    );
  }
}