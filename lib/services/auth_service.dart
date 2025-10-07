import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:dio/dio.dart';
import '../config/api_config.dart';

class AuthService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _pinflKey = 'pinfl';

  final Dio _dio;

  AuthService({Dio? dio})
      : _dio = dio ?? Dio(BaseOptions(
    baseUrl: ApiConfig.baseUrl, // ← O'zgargan qism
    connectTimeout: ApiConfig.connectTimeout,
    receiveTimeout: ApiConfig.receiveTimeout,
  ));

  // Login metodi
  Future<Map<String, dynamic>> login(String pinfl, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'username': pinfl,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['access_token'] != null && response.data['access_token'].isNotEmpty) {
        final data = response.data;

        // Tokenlar va PINFL ni saqlash
        await saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          pinfl: pinfl,
        );

        return {
          'success': true,
          'message': 'Login muvaffaqiyatli',
          'data': data,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login xatolik',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Serverga ulanishda xatolik',
      };
    } catch (e) {
      print(e);
      return {
        'success': false,
        'message': 'Kutilmagan xatolik: $e',
      };
    }
  }

  // Token va PINFL saqlash
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String pinfl,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
    await prefs.setString(_refreshTokenKey, refreshToken);
    await prefs.setString(_pinflKey, pinfl);
  }

  // Access token olish
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getValidAccessToken() async {
    final token = await getAccessToken();
    if (token == null) return null;

    if (JwtDecoder.isExpired(token)) {
      final refreshed = await refreshToken();
      if (!refreshed) return null;
      return await getAccessToken();
    }
    return token;
  }

  // Refresh token olish
  Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  // PINFL olish
  Future<String?> getPinfl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinflKey);
  }

  // Logout - barcha ma'lumotlarni o'chirish
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_pinflKey);
  }

  // Login tekshirish
  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // Token yangilash (refresh)
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await saveTokens(
          accessToken: data['access_token'],
          refreshToken: data['refresh_token'],
          pinfl: await getPinfl() ?? '',
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}