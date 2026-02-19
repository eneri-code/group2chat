import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Center(
        child: Obx(() {
          final user = authController.firebaseUser.value;

          if (user == null) {
            return const Text("No user data");
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.person, size: 80),
              const SizedBox(height: 20),
              Text("Email: ${user.email}"),
              const SizedBox(height: 10),
              Text("User ID: ${user.uid}"),
            ],
          );
        }),
      ),
    );
  }
}
