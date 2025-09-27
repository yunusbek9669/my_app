import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      title: 'Bu Title',
      initialRoute: '/login',
      routes: {
        '/': (context) => const HomePage(),
        '/adding': (context) => const AddingPage(),
        '/settings': (context) => const SettingsPage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
