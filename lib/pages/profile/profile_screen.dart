import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/pages/profile/profile_menu_widget.dart';
import 'package:my_app/pages/profile/update_profile_screen.dart';

import '../../models/user_info.dart';
import '../../services/auth_service.dart';
import '../../utils.dart';

class ProfileScreen extends StatelessWidget {
  final UserInfo? userInfo;
  const ProfileScreen({Key? key, this.userInfo, required Future<void> Function() onLogout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    final imageBytes = base64FromDataUri(userInfo!.imageUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile", style: Theme.of(context).textTheme.displayMedium),
        iconTheme: const IconThemeData(
          color: Colors.white, // drawer icon rangi
          size: 30,            // icon kattaligi
        ),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [

              /// -- IMAGE
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100), child: Hero(
                      tag: "userInfo-${userInfo!.username ?? 'unknown'}",
                      child: Image.memory(
                        imageBytes,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ))
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.amber),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(userInfo!.fullName, style: Theme.of(context).textTheme.bodyLarge),
              Text(userInfo!.title, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 20),

              /// -- BUTTON
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const UpdateProfileScreen()),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent, side: BorderSide.none, shape: const StadiumBorder()),
                  child: const Text("edit Profile", style: TextStyle(color: Colors.black45)),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),

              /// -- MENU
              ProfileMenuWidget(title: "Settings", icon: const Icon(Icons.settings_rounded), onPress: () {}),
              ProfileMenuWidget(title: "Billing Details", icon: const Icon(Icons.wallet), onPress: () {}),
              ProfileMenuWidget(title: "User Management", icon: const Icon(Icons.check_circle_outline), onPress: () {}),
              const Divider(),
              const SizedBox(height: 10),
              ProfileMenuWidget(title: "Information", icon: const Icon(Icons.info), onPress: () {}),
              ProfileMenuWidget(
                  title: "Logout",
                  icon: const Icon(Icons.logout, color: Colors.red),
                  textColor: Colors.red,
                  endIcon: false,
                  onPress: () async {
                    await authService.logout();
                    // logout bo‘lgach login page’ga qaytaramiz
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/login',
                          (route) => false, // barcha stackni tozalash
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}