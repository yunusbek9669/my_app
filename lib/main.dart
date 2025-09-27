import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/pages/adding_page.dart';
import 'package:my_app/pages/home_page.dart';
import 'package:my_app/pages/profile_page.dart';
import 'package:my_app/pages/settings_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final _storage = const FlutterSecureStorage();

  // Token bor-yo‘qligini tekshirish
  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: "access_token");
    return token != null;
  }

  // Route guard
  Widget authGuard(Widget page) {
    return FutureBuilder<bool>(
      future: isLoggedIn(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return page; // Login bo‘lsa sahifa
        } else {
          return const LoginPage(); // Login qilmagan bo‘lsa LoginPage
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'Bu Title',
      initialRoute: '/',
      routes: {
        '/': (context) => authGuard(const HomePage()),
        '/adding': (context) => authGuard(const AddingPage()),
        '/settings': (context) => authGuard(const SettingsPage()),
        '/profile': (context) => authGuard(const ProfilePage()),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
