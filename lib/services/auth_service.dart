import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://192.168.1.32/api")); // 🔹 backend url
  final storage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    try {
      final response = await dio.post(
        "/auth/login",
        data: {
          "username": username,
          "password": password,
        },
        options: Options(contentType: Headers.jsonContentType),
      );

      final data = response.data;
      final accessToken = data['access_token']; // tokenni oldik

      if (response.statusCode == 200 && response.data["access_token"] != null) {
        // Tokenni secure storage’ga yozamiz
        await storage.write(key: "access_token", value: response.data["access_token"]);
        if (response.data["refresh_token"] != null) {
          await storage.write(key: "refresh_token", value: response.data["refresh_token"]);
        }
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Login xatolik: $e");
      return false;
    }
  }

  Future<String?> getAccessToken() async {
    return await storage.read(key: "access_token");
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
}
