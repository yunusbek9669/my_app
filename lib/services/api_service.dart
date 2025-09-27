import 'package:dio/dio.dart';
import '../models/nature.dart';

class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<List<Nature>> fetchCertificates() async {
    try {
      final response = await _dio.get("/certificate/certificates-for-test");

      print("Response data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map && response.data.containsKey("data")) {
          List<dynamic> data = response.data["data"];
          return data.map((json) => Nature.fromJson(json)).toList();
        } else {
          throw Exception("Kutilmagan javob: ${response.data}");
        }
      } else {
        throw Exception("Xatolik: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("API chaqirishda xato: $e");
    }
  }
}
