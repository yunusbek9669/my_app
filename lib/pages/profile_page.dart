import 'package:flutter/material.dart';
import "package:flutter_svg/flutter_svg.dart";
import '../models/user.dart';
import '../services/api_client.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../utils.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? user;
  ApiService? api;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initApi();
  }

  Future<void> initApi() async {
    final accessToken = await AuthService().getAccessToken();
    if (accessToken == null) return;

    final client = await ApiClient.create(
      "http://localhost:8080/api",
      token: accessToken,
    );

    setState(() {
      api = ApiService(client.dio, context);
    });

    await loadData();
  }

  Future<void> loadData() async {
    if (api == null) return;
    try {
      final data = await api!.fetchUser();
      setState(() {
        user = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileScreen(user: user, loading: loading); // 🔹 shu joyda chaqirasiz
  }
}

class ProfileScreen extends StatelessWidget {
  final User? user;
  final bool loading;

  const ProfileScreen({super.key, required this.user, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            ProfilePic(user: user, loading: loading),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "My Account",
              icon: "assets/icons/User Icon.svg",
              press: () => {},
            ),
            ProfileMenu(
              text: "Notifications",
              icon: "assets/icons/Bell.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Settings",
              icon: "assets/icons/Settings.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Help Center",
              icon: "assets/icons/Question mark.svg",
              press: () {},
            ),
            ProfileMenu(
              text: "Log Out",
              icon: "assets/icons/Log out.svg",
              press: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  final User? user;
  final bool loading;

  const ProfilePic({Key? key, required this.user, required this.loading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return const Center(child: Text("Foydalanuvchi maʼlumoti topilmadi"));
    }

    final imageBytes = base64FromDataUri(user!.imageUrl);

    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Hero(
            tag: "user-${user!.username ?? 'unknown'}",
            child: Image.memory(
              imageBytes,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(color: Colors.white),
                  ),
                  backgroundColor: const Color(0xFFF5F6F9),
                ),
                onPressed: () {},
                child: const Icon(
                  Icons.camera_alt,
                  color: Colors.black45,
                  size: 16,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFFFF7643),
          padding: const EdgeInsets.all(20),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: const Color(0xFFF5F6F9),
        ),
        onPressed: press,
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              colorFilter:
              const ColorFilter.mode(Color(0xFFFF7643), BlendMode.srcIn),
              width: 22,
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF757575),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF757575),
            ),
          ],
        ),
      ),
    );
  }
}
