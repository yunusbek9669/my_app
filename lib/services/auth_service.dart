import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio dio = Dio(BaseOptions(baseUrl: "http://localhost:8080/api")); // 🔹 backend url
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
        await storage.write(key: "user", value: response.data);
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

  Future<String?> getUser() async {
    return await storage.read(key: "user");
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }
}
