import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/nature.dart';
import '../models/user_info.dart';
import 'auth_service.dart';

class ApiService {
  final Dio dio;

  ApiService(this.dio);

  Future<List<Nature>> fetchCertificates() async {
    try {
      final String? token = await AuthService().getAccessToken();
      if (token == null) {
        throw Exception("Token topilmadi!");
      }

      final response = await dio.post(
        "/certificate/certificates-for-test",
        data: ["NV-I"],
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      // Response strukturasini tekshirish
      final responseData = response.data;

      // Agar data o'rniga to'g'ridan-to'g'ri status, code, message bo'lsa
      if (responseData is Map && responseData.containsKey('status') && responseData.containsKey('message')) {
        final status = responseData['status'];
        final code = responseData['code'];
        final message = responseData['message'];

        // 201 - warning, 200 - success, boshqalar - error
        if (status == 201) {
          // Warning - ma'lumot yo'q, lekin kritik xato emas
          throw ApiWarningException(message ?? 'Ogohlantirish', code: code);
        } else if (status != 200) {
          // Error
          throw ApiErrorException(message ?? 'Noma\'lum xatolik', code: code);
        }
      }

      // Normal holat: data mavjud
      final data = responseData["data"];

      if (data == null) {
        return [];
      }

      if (data is List) {
        return data
            .map((json) => Nature.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (data is Map) {
        return [Nature.fromJson(data.cast<String, dynamic>())];
      } else {
        throw Exception("Kutilmagan javob formati: $data");
      }
    } on DioException catch (e) {
      debugPrint("API xatolik: ${e.message}");
      debugPrint("Response: ${e.response?.data}");
      rethrow;
    } catch (e) {
      debugPrint("Umumiy xatolik: $e");
      rethrow;
    }
  }

  Future<UserInfo> fetchUser(String pinfl) async {
    try {
      final String? token = await AuthService().getAccessToken();
      if (token == null) {
        throw Exception("Token topilmadi!");
      }

      debugPrint('Fetching user with PINFL: $pinfl');

      final response = await dio.post(
        "/adaptive/get-reference-data?count=1&last_number=0&jshshir=$pinfl",
        data: {"user": "{users}.*"},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      // Status tekshirish
      if (response.data['status'] != null && response.data['status'] != true) {
        throw Exception(response.data['message'] ?? 'Foydalanuvchi topilmadi');
      }

      final userData = response.data["items"][0]['user'];
      if (userData == null) {
        throw Exception("Foydalanuvchi ma'lumoti topilmadi");
      }

      return UserInfo.fromJson(userData);
    } on DioException catch (e) {
      debugPrint("API xatolik: ${e.message}");
      debugPrint("Response: ${e.response?.data}");
      rethrow;
    } catch (e) {
      debugPrint("Umumiy xatolik: $e");
      rethrow;
    }
  }

  // Xatoliklarni UI da ko'rsatish uchun helper metod
  static void handleError(BuildContext context, dynamic error) {
    String message = 'Xatolik yuz berdi';
    Color backgroundColor = Colors.red;
    IconData icon = Icons.error;

    if (error is ApiWarningException) {
      // Warning - sariq rang
      message = error.message;
      backgroundColor = Colors.orange;
      icon = Icons.warning_amber;
    } else if (error is ApiErrorException) {
      // Error - qizil rang
      message = error.message;
      backgroundColor = Colors.red;
      icon = Icons.error_outline;
    } else if (error is DioException) {
      if (error.response != null) {
        message = error.response?.data['message'] ?? 'Server xatoligi';
      } else if (error.type == DioExceptionType.connectionTimeout) {
        message = 'Serverga ulanish vaqti tugadi';
      } else if (error.type == DioExceptionType.receiveTimeout) {
        message = 'Javob kutish vaqti tugadi';
      } else {
        message = 'Internetga ulanishda xatolik';
      }
    } else if (error is Exception) {
      message = error.toString().replaceAll('Exception: ', '');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }
}

// Custom exception klasslari
class ApiWarningException implements Exception {
  final String message;
  final String? code;

  ApiWarningException(this.message, {this.code});

  @override
  String toString() => message;
}

class ApiErrorException implements Exception {
  final String message;
  final String? code;

  ApiErrorException(this.message, {this.code});

  @override
  String toString() => message;
}

// Foydalanish misoli:
/*
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final ApiService apiService = ApiService(Dio(BaseOptions(baseUrl: "https://api.example.com")));
  List<Nature> certificates = [];
  bool isLoading = false;

  Future<void> loadCertificates() async {
    setState(() => isLoading = true);

    try {
      certificates = await apiService.fetchCertificates();
      setState(() {});
    } on ApiWarningException catch (e) {
      // Warning - ma'lumot yo'q, lekin davom etish mumkin
      if (mounted) {
        ApiService.handleError(context, e); // Sariq rangli ogohlantirish
      }
      setState(() => certificates = []); // Bo'sh ro'yxat
    } on ApiErrorException catch (e) {
      // Critical error - qizil rangli xabar
      if (mounted) {
        ApiService.handleError(context, e);
      }
    } catch (e) {
      // Boshqa xatoliklar
      if (mounted) {
        ApiService.handleError(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> loadUser(String pinfl) async {
    try {
      final user = await apiService.fetchUser(pinfl);
      // User bilan ishlash...
    } catch (e) {
      if (mounted) {
        ApiService.handleError(context, e);
      }
    }
  }
}
*/