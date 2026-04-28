import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:quran_player_app/data/repositories/surah_repository.dart';
import 'package:quran_player_app/data/sources/api_service.dart';

void main() {
  late SurahRepository repository;

  setUp(() {
    final apiService =
        ApiService(); // Menggunakan ApiService asli untuk integrasi test sederhana
    repository = SurahRepository(apiService);
  });

  group('Surah Repository Test', () {
    test('Harus mengembalikan 114 surah dari API', () async {
      final result = await repository.getSurahList();
      expect(result.length, 114);
      expect(result[0].englishName, 'Al-Faatiha');
    });

    test('Harus mengembalikan detail surah Al-Fatihah dengan audio', () async {
      final result = await repository.getSurahDetail(1);
      expect(result.number, 1);
      expect(result.ayahs, isNotEmpty);
      expect(result.ayahs![0].audio, contains('.mp3'));
    });
  });
}
