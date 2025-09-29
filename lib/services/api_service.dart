import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/nature.dart';
import '../models/user.dart';
import 'auth_service.dart';

class ApiService {
  final Dio dio;
  final BuildContext context;

  ApiService(this.dio, this.context);

  Future<List<Nature>> fetchCertificates() async {
    try {
      final String? token = await AuthService().getAccessToken();
      if (token == null) throw Exception("Token topilmadi!");

      final response = await dio.post(
        "/certificate/certificates-for-test",
        data: ["AV-II"],
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      final responseData = response.data["data"];

      if (responseData is List) {
        return responseData
            .map((json) => Nature.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (responseData is Map) {
        return [Nature.fromJson(responseData.cast<String, dynamic>())];
      } else {
        throw Exception("Kutilmagan javob: $responseData");
      }
    } on DioException catch (e) {
      print("API xatolik: $e");
      return [];
    }
  }

  Future<User> fetchUser() async {
    try {
      final String? token = await AuthService().getAccessToken();
      if (token == null) throw Exception("Token topilmadi!");

      final response = await dio.post(
        "/user/user",
        data: {"pinfl": 33008965210023},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return User.fromJson(response.data["data"]); // ✅ User qaytaradi
    } on DioException catch (e) {
      print("API xatolik: $e");
      rethrow; // ❌ bo‘sh user qaytarmang
    }
  }
}
