import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quran_player_app/logic/search_bloc/search_bloc.dart';
import 'package:quran_player_app/logic/search_bloc/search_event.dart';
import 'package:quran_player_app/logic/search_bloc/search_state.dart';
import 'package:quran_player_app/data/models/surah_model.dart';
import 'package:mocktail/mocktail.dart'; // Tambahkan package mocktail di pubspec
import 'package:quran_player_app/data/repositories/surah_repository.dart';

class MockSurahRepository extends Mock implements SurahRepository {}

void main() {
  late SearchBloc searchBloc;
  late MockSurahRepository mockRepo;

  setUp(() {
    mockRepo = MockSurahRepository();
    searchBloc = SearchBloc(mockRepo);
  });

  // Contoh Test: Memastikan filter pencarian bekerja
  blocTest<SearchBloc, SearchState>(
    'Harus memfilter surah berdasarkan query "Al-Fatihah"',
    build: () {
      // Mock data awal
      final dummySurah = [
        SurahModel(
          number: 1,
          name: '..',
          englishName: 'Al-Faatiha',
          englishNameTranslation: '..',
          numberOfAyahs: 7,
          revelationType: 'Meccan',
        ),
        SurahModel(
          number: 2,
          name: '..',
          englishName: 'Al-Baqara',
          englishNameTranslation: '..',
          numberOfAyahs: 286,
          revelationType: 'Medinan',
        ),
      ];
      // Berikan state awal seolah-olah data sudah di-load
      return searchBloc;
    },
    seed: () => SearchLoaded(
      allSurah: [
        SurahModel(
          number: 1,
          name: '..',
          englishName: 'Al-Faatiha',
          englishNameTranslation: '..',
          numberOfAyahs: 7,
          revelationType: 'Meccan',
        ),
        SurahModel(
          number: 2,
          name: '..',
          englishName: 'Al-Baqara',
          englishNameTranslation: '..',
          numberOfAyahs: 286,
          revelationType: 'Medinan',
        ),
      ],
      filteredSurah: [],
    ),
    act: (bloc) => bloc.add(FilterSurah('Fatihah')),
    expect: () => [
      isA<SearchLoaded>().having((s) => s.filteredSurah.length, 'length', 1),
    ],
  );
}
