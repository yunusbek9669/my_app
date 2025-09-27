import 'package:flutter/material.dart';
import '../main_layout.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Settings",
      body: const Center(
        child: Text("Settings Page Content"),
      ),
      currentIndex: 2,
      onTabTapped: (index) {
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/search');
        }
      },
    );
  }
}