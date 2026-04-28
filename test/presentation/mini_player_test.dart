import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quran_player_app/logic/player_bloc/player_bloc.dart';
import 'package:quran_player_app/logic/player_bloc/player_state.dart';
import 'package:quran_player_app/presentation/widgets/mini_player.dart';
import 'package:quran_player_app/data/models/surah_model.dart';

class MockPlayerBloc extends Mock implements PlayerBloc {}

void main() {
  testWidgets('MiniPlayer muncul saat ada surah yang sedang aktif', (
    tester,
  ) async {
    final mockBloc = MockPlayerBloc();
    final mockSurah = SurahModel(
      number: 1,
      name: '..',
      englishName: 'Al-Faatiha',
      englishNameTranslation: '..',
      numberOfAyahs: 7,
      revelationType: 'Meccan',
    );

    when(
      () => mockBloc.state,
    ).thenReturn(PlayerState(currentSurah: mockSurah, isPlaying: true));
    when(() => mockBloc.stream).thenAnswer((_) => Stream.value(mockBloc.state));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<PlayerBloc>.value(
          value: mockBloc,
          child: const Scaffold(bottomNavigationBar: MiniPlayer()),
        ),
      ),
    );

    expect(find.text('Al-Faatiha'), findsOneWidget);
    expect(find.byIcon(Icons.pause), findsOneWidget);
  });
}
