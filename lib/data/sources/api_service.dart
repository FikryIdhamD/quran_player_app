import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.alquran.cloud/v1/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Menambahkan logger untuk memantau request di console
  ApiService() {
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
  }

  Dio get browser => _dio;
}
