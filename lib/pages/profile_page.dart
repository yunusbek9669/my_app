import 'package:flutter/material.dart';
import 'package:my_app/pages/profile/profile_screen.dart';
import '../models/user_info.dart';
import '../services/api_client.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserInfo? userInfo;
  ApiService? api;
  bool loading = true;
  String? errorMessage;
  String? pinfl; // PINFL ni saqlash uchun

  @override
  void initState() {
    super.initState();
    initApi();
  }

  Future<void> initApi() async {
    try {
      final accessToken = await AuthService().getAccessToken();

      if (accessToken == null) {
        // Token yo'q bo'lsa login sahifasiga
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
        return;
      }

      // PINFL ni olish (AuthService'dan yoki SharedPreferences'dan)
      pinfl = await AuthService().getPinfl(); // Bu metodingiz bo'lishi kerak

      if (pinfl == null) {
        if (mounted) {
          setState(() {
            loading = false;
            errorMessage = 'PINFL topilmadi';
          });
        }
        return;
      }

      final client = await ApiClient.create(
        "http://localhost:8080/api",
        token: accessToken,
      );

      if (mounted) {
        setState(() {
          api = ApiService(client.dio);
        });
        await loadData();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          loading = false;
          errorMessage = 'Tizimga ulanishda xatolik';
        });
      }
    }
  }

  Future<void> loadData() async {
    if (api == null || pinfl == null) return;

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await api!.fetchUser(pinfl!); // ✅ PINFL uzatildi

      if (mounted) {
        setState(() {
          userInfo = data;
          loading = false;
        });
      }
    } on ApiWarningException catch (e) {
      // Warning holati
      if (mounted) {
        ApiService.handleError(context, e);
        setState(() {
          loading = false;
          errorMessage = e.message;
        });
      }
    } on ApiErrorException catch (e) {
      // Error holati
      if (mounted) {
        ApiService.handleError(context, e);
        setState(() {
          loading = false;
          errorMessage = e.message;
        });
      }
    } catch (e) {
      // Boshqa xatoliklar
      if (mounted) {
        ApiService.handleError(context, e);
        setState(() {
          loading = false;
          errorMessage = 'Foydalanuvchi ma\'lumotini yuklashda xatolik';
        });
      }
    }
  }

  Future<void> logout() async {
    try {
      await AuthService().logout();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ApiService.handleError(context, e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading holati
    if (loading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Yuklanmoqda...'),
          ],
        ),
      );
    }

    // Xatolik holati
    if (errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: loadData,
                icon: const Icon(Icons.refresh),
                label: const Text('Qayta urinish'),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: logout,
                icon: const Icon(Icons.logout),
                label: const Text('Chiqish'),
              ),
            ],
          ),
        ),
      );
    }

    // Ma'lumot topilmadi
    if (userInfo == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Foydalanuvchi ma\'lumoti topilmadi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Qayta yuklash'),
            ),
          ],
        ),
      );
    }

    // Muvaffaqiyatli - ProfileScreen ko'rsatish
    return RefreshIndicator(
      onRefresh: loadData,
      child: ProfileScreen(
        userInfo: userInfo!,
        onLogout: logout, // Agar ProfileScreen'da logout kerak bo'lsa
      ),
    );
  }
}

// OPTIONAL: ProfileScreen uchun onLogout parametri
// profile_screen.dart faylida:
/*
class ProfileScreen extends StatelessWidget {
  final UserInfo userInfo;
  final VoidCallback? onLogout;

  const ProfileScreen({
    Key? key,
    required this.userInfo,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        actions: [
          if (onLogout != null)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onLogout,
              tooltip: 'Chiqish',
            ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // User info ko'rsatish
              CircleAvatar(
                radius: 50,
                child: Text(
                  userInfo.firstName[0].toUpperCase(),
                  style: const TextStyle(fontSize: 32),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${userInfo.firstName} ${userInfo.lastName}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Qolgan ma'lumotlar...
            ],
          ),
        ),
      ),
    );
  }
}
*/