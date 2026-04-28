import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player_app/data/repositories/surah_repository.dart';
import 'package:quran_player_app/data/sources/api_service.dart';

void main() {
  late ApiService apiService;
  late SurahRepository repository;

  setUp(() {
    apiService = ApiService();
    repository = SurahRepository(apiService);
  });

  group('Surah Repository Test', () {
    test('Harus mengembalikan daftar 114 surah', () async {
      final surahs = await repository.getSurahList();

      expect(surahs.isNotEmpty, true);
      expect(surahs.length, 114);
      expect(surahs[0].englishName, 'Al-Faatiha');
    });

    test('Harus mengembalikan detail surah dengan list audio ayahs', () async {
      final surah = await repository.getSurahDetail(1);

      expect(surah.number, 1);
      expect(surah.ayahs != null, true);
      expect(surah.ayahs!.isNotEmpty, true);
      // Memastikan URL audio mengandung .mp3
      expect(surah.ayahs![0].audio.contains('.mp3'), true);
    });
  });
}
