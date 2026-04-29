// File: lib/data/sources/api_service.dart

import 'package:dio/dio.dart';

/// Service untuk mengelola semua HTTP request ke API AlQuran.cloud menggunakan Dio.
class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.alquran.cloud/v1/',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  ApiService() {
    // Menambahkan LogInterceptor untuk debugging request & response di console
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  /// Getter untuk mengakses instance Dio yang sudah dikonfigurasi.
  Dio get browser => _dio;
}
