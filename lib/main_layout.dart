import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final int currentIndex;
  final Function(int)? onTabTapped;

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex = 0,
    this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white, // drawer icon rangi
          size: 30,            // icon kattaligi
        ),
        backgroundColor: Colors.indigo,
      ),

      // ✅ Sidebar (Drawer)
      drawer: Drawer(
        backgroundColor: Colors.indigo[100],
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Profile"),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/settings');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout", style: TextStyle(color: Colors.red)),
              onTap: () async {
                await authService.logout();
                // logout bo‘lgach login page’ga qaytaramiz
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (route) => false, // barcha stackni tozalash
                );
              },
            ),
          ],
        ),
      ),

      // ✅ Kontent qismi
      body: body,

      // ✅ BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTapped,
        selectedItemColor: Colors.indigo,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
