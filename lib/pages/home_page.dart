import 'package:flutter/material.dart';
import 'package:my_app/widgets/my-card.dart';
import '../main_layout.dart';
import '../models/nature.dart';
import '../services/api_client.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService? api;
  List<Nature> list = [];
  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    initApi();
  }

  Future<void> initApi() async {
    try {
      final authService = AuthService();
      final accessToken = await authService.getAccessToken();

      if (accessToken == null) {
        // Token yo'q bo'lsa login sahifasiga yo'naltirish
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
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
      debugPrint('initApi xatolik: $e');
      if (mounted) {
        setState(() {
          loading = false;
          errorMessage = 'Tizimga ulanishda xatolik: ${e.toString()}';
        });
      }
    }
  }

  Future<void> loadData() async {
    if (api == null) return;

    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      final data = await api!.fetchCertificates();

      if (mounted) {
        setState(() {
          list = data;
          loading = false;
        });
      }
    } on ApiWarningException catch (e) {
      // Warning - ma'lumot yo'q lekin kritik emas
      if (mounted) {
        ApiService.handleError(context, e);
        setState(() {
          list = [];
          loading = false;
        });
      }
    } on ApiErrorException catch (e) {
      // Critical error
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
          errorMessage = 'Ma\'lumotlarni yuklashda xatolik';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Nature Wallpapers",
      currentIndex: 0,
      onTabTapped: (index) {
        if (index == 1) {
          Navigator.pushReplacementNamed(context, '/search');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/profile');
        }
      },
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Loading holati
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Xatolik holati
    if (errorMessage != null) {
      return Center(
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
          ],
        ),
      );
    }

    // Bo'sh ro'yxat holati
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Ma\'lumot topilmadi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Yangilash'),
            ),
          ],
        ),
      );
    }

    // Muvaffaqiyatli holat - ro'yxat ko'rsatish
    return RefreshIndicator(
      onRefresh: loadData,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          return MyCard(nature: list[index]);
        },
      ),
    );
  }
}

// OPTIONAL: Agar loading indicator dizayni bo'lsa
class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Yuklanmoqda...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}