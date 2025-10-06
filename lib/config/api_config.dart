class ApiConfig {
  // Development (local server)
  static const String devBaseUrl = 'http://192.168.1.114:8080/api'; // ← O'z IP ingizni yozing

  // Production (real server)
  static const String prodBaseUrl = 'https://api.example.com';

  // Current environment
  static const bool isDevelopment = true; // false qiling production uchun

  // Active base URL
  static String get baseUrl => isDevelopment ? devBaseUrl : prodBaseUrl;

  // Connection timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Debug mode
  static const bool enableLogging = true;
}

// Ishlatish:
// import '../config/api_config.dart';
//
// final client = await ApiClient.create(
//   ApiConfig.baseUrl,
//   token: accessToken,
// );