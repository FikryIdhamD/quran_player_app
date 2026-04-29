// File: lib/data/repositories/surah_repository.dart

import '../models/surah_model.dart';
import '../sources/api_service.dart';

/// Repository yang bertanggung jawab mengambil data Surah dari API.
/// Berperan sebagai jembatan antara ApiService dan business logic.
class SurahRepository {
  final ApiService apiService;

  SurahRepository(this.apiService);

  /// Mengambil daftar semua surah (114 surah) untuk katalog utama.
  Future<List<SurahModel>> getSurahList() async {
    try {
      final response = await apiService.browser.get('surah');

      // Data surah berada di dalam key 'data'
      final List<dynamic> data = response.data['data'] as List<dynamic>;

      return data
          .map((json) => SurahModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar surah: $e');
    }
  }

  /// Mengambil detail satu surah beserta seluruh ayat dan audio-nya.
  /// Menggunakan qari Ar.alafasy sesuai endpoint yang dibutuhkan.
  Future<SurahModel> getSurahDetail(int number) async {
    try {
      final response = await apiService.browser.get('surah/$number/ar.alafasy');

      return SurahModel.fromJson(response.data['data'] as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Gagal mengambil detail surah nomor $number: $e');
    }
  }
}
