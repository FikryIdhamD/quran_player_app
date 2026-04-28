import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_player_app/logic/player_bloc/player_bloc.dart';
import 'package:quran_player_app/logic/player_bloc/player_event.dart';
import 'package:quran_player_app/data/repositories/surah_repository.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {}

class MockSurahRepository extends Mock implements SurahRepository {}

void main() {
  late PlayerBloc playerBloc;
  late MockAudioPlayer mockPlayer;
  late MockSurahRepository mockRepo;

  // test/logic/player_bloc_test.dart

  setUp(() {
    mockPlayer = MockAudioPlayer();
    mockRepo = MockSurahRepository();

    // STUBBING WAJIB: Kasih kembalian Future agar tidak error Null
    when(
      () => mockPlayer.positionStream,
    ).thenAnswer((_) => const Stream.empty());
    when(() => mockPlayer.pause()).thenAnswer((_) async => {}); // Tambahkan ini
    when(() => mockPlayer.play()).thenAnswer((_) async => {}); // Tambahkan ini
    when(
      () => mockPlayer.seek(any()),
    ).thenAnswer((_) async => {}); // Tambahkan ini

    playerBloc = PlayerBloc(mockRepo, mockPlayer);
  });
}
