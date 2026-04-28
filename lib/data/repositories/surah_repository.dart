import '../models/surah_model.dart';
import '../sources/api_service.dart';

class SurahRepository {
  final ApiService apiService;

  SurahRepository(this.apiService);

  // Fungsi untuk List Surah (Katalog)
  Future<List<SurahModel>> getSurahList() async {
    try {
      final response = await apiService.browser.get('surah');
      final List data = response.data['data'];
      return data.map((json) => SurahModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil daftar surah: $e');
    }
  }

  // Fungsi untuk Detail Surah (Audio Ayat)
  Future<SurahModel> getSurahDetail(int number) async {
    try {
      // Kita pakai ar.alafasy sesuai endpoint yang kamu kasih tadi
      final response = await apiService.browser.get('surah/$number/ar.alafasy');
      return SurahModel.fromJson(response.data['data']);
    } catch (e) {
      throw Exception('Gagal mengambil audio surah: $e');
    }
  }
}
