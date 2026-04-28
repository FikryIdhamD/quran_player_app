import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player_app/data/models/surah_model.dart';
import 'package:quran_player_app/data/repositories/surah_repository.dart';
import 'package:quran_player_app/logic/search_bloc/search_bloc.dart';
import 'package:quran_player_app/logic/search_bloc/search_event.dart';
import 'package:quran_player_app/logic/search_bloc/search_state.dart';

class MockSurahRepository extends Mock implements SurahRepository {}

void main() {
  late MockSurahRepository mockRepo;
  final mockSurahs = [
    SurahModel(
      number: 1,
      name: '..',
      englishName: 'Al-Faatiha',
      englishNameTranslation: '..',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    ),
  ];

  setUp(() {
    mockRepo = MockSurahRepository();
  });

  blocTest<SearchBloc, SearchState>(
    'Emits [Loading, Loaded] saat FetchSurahList berhasil',
    build: () {
      when(() => mockRepo.getSurahList()).thenAnswer((_) async => mockSurahs);
      return SearchBloc(mockRepo);
    },
    act: (bloc) => bloc.add(FetchSurahList()),
    expect: () => [
      isA<SearchLoading>(),
      isA<SearchLoaded>().having((s) => s.allSurah.length, 'total', 1),
    ],
  );

  blocTest<SearchBloc, SearchState>(
    'FilterSurah harus memberikan hasil yang sesuai query',
    build: () => SearchBloc(mockRepo),
    seed: () => SearchLoaded(allSurah: mockSurahs, filteredSurah: mockSurahs),
    act: (bloc) => bloc.add(FilterSurah('Faatiha')),
    expect: () => [
      isA<SearchLoaded>().having(
        (s) => s.filteredSurah.length,
        'hasil filter',
        1,
      ),
    ],
  );
}
