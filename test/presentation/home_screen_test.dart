import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
// Ingat: sembunyikan PlayerState milik just_audio agar tidak bentrok
import 'package:just_audio/just_audio.dart' hide PlayerState;

import 'package:quran_player_app/presentation/screens/home_screen.dart';
import 'package:quran_player_app/logic/search_bloc/search_bloc.dart';
import 'package:quran_player_app/logic/search_bloc/search_state.dart';
import 'package:quran_player_app/logic/player_bloc/player_bloc.dart';
import 'package:quran_player_app/logic/player_bloc/player_state.dart';

// 1. Definisikan Mock untuk kedua Bloc
class MockSearchBloc extends Mock implements SearchBloc {}

class MockPlayerBloc extends Mock implements PlayerBloc {}

void main() {
  late MockSearchBloc mockSearchBloc;
  late MockPlayerBloc mockPlayerBloc;

  setUp(() {
    mockSearchBloc = MockSearchBloc();
    mockPlayerBloc = MockPlayerBloc();

    // 2. Stubbing SearchBloc: Kasih state awal agar tidak null
    when(() => mockSearchBloc.state).thenReturn(SearchInitial());
    when(() => mockSearchBloc.stream).thenAnswer((_) => const Stream.empty());

    // 3. Stubbing PlayerBloc: Ini yang krusial agar MiniPlayer tidak crash
    when(() => mockPlayerBloc.state).thenReturn(const PlayerState());
    when(() => mockPlayerBloc.stream).thenAnswer((_) => const Stream.empty());
  });

  testWidgets('HomeScreen harus menampilkan Judul dan Search Bar tanpa crash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MultiBlocProvider(
          providers: [
            BlocProvider<SearchBloc>.value(value: mockSearchBloc),
            BlocProvider<PlayerBloc>.value(value: mockPlayerBloc),
          ],
          child: const HomeScreen(),
        ),
      ),
    );

    // 5. Verifikasi elemen UI muncul
    expect(find.text('Quran Player'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);

    // Opsional: Cek apakah Search Bar punya hint yang benar
    expect(find.text('Search Surah...'), findsOneWidget);
  });
}
