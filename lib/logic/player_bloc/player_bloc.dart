import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'player_event.dart';
import 'player_state.dart';
import '../../data/repositories/surah_repository.dart';
import '../../data/services/audio_handler.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final SurahRepository repository;
  final AudioPlayer player;

  PlayerBloc(this.repository, this.player) : super(const PlayerState()) {
    final audioHandler = AudioHandler(player);

    // Dengerin perubahan posisi lagu secara real-time
    player.positionStream.listen((pos) {
      add(UpdatePosition(pos, player.duration ?? Duration.zero));
    });

    on<PlaySurah>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final detail = await repository.getSurahDetail(event.surahNumber);
        await audioHandler.setSurahPlaylist(detail);
        player.play();
        emit(
          state.copyWith(
            currentSurah: detail,
            isPlaying: true,
            isLoading: false,
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false));
      }
    });

    on<TogglePlay>((event, emit) {
      if (player.playing) {
        player.pause();
        emit(state.copyWith(isPlaying: false));
      } else {
        player.play();
        emit(state.copyWith(isPlaying: true));
      }
    });

    on<UpdatePosition>((event, emit) {
      emit(state.copyWith(position: event.position, duration: event.duration));
    });

    on<Seek>((event, emit) {
      player.seek(
        event.position,
      ); // Memerintah just_audio pindah ke detik tertentu
    });
  }
}
