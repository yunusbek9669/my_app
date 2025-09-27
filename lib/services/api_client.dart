import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  static Future<ApiClient> create(String baseUrl) async {
    final dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    ));

    // 🔹 bu yerga haqiqiy tokeningizni yozasiz
    const token = "changeme_REPLACE_WITH_STRONG_KEY";

    dio.options.headers["Authorization"] = "Bearer $token";

    return ApiClient._(dio);
  }
}
