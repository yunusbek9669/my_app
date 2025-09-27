import 'package:flutter/material.dart';
import 'package:my_app/widgets/my-card.dart';
import '../main_layout.dart';
import '../models/nature.dart';
import '../services/api_client.dart';
import '../services/api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService? api;
  List<Nature> list = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    initApi();
  }

  Future<void> initApi() async {
    final client = await ApiClient.create("http://iiv-guvohnoma/api");
    setState(() {
      api = ApiService(client.dio);
    });
    await loadData();
  }

  Future<void> loadData() async {
    if (api == null) return;
    try {
      final data = await api!.fetchCertificates();
      setState(() {
        list = data;
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("Xatolik: $e");
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return MyCard(nature: list[index]);
        },
      ),
    );
  }
}
