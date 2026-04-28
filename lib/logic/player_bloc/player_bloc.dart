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

    player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(NextSurah());
      }
    });

    on<PlaySurah>((event, emit) async {
      await player.pause();
      player.setLoopMode(LoopMode.off);
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

    on<NextSurah>((event, emit) {
      if (state.currentSurah == null) return; // safety check

      final nextNumber = state.currentSurah!.number + 1;
      if (nextNumber <= 114) {
        add(PlaySurah(nextNumber)); // reuse PlaySurah yang sudah ada
      }
      // kalau sudah di surah 114, tidak lakukan apa-apa
    });

    on<PreviousSurah>((event, emit) {
      if (state.currentSurah == null) return;

      final prevNumber = state.currentSurah!.number - 1;
      if (prevNumber >= 1) {
        add(PlaySurah(prevNumber));
      }
      // kalau sudah di surah 1, tidak lakukan apa-apa
    });

    on<ToggleRepeat>((event, emit) {
      if (state.currentSurah == null) return;

      final newRepeating = !state.isRepeating;
      final newLoopMode = newRepeating ? LoopMode.all : LoopMode.off;

      // Terapkan ke just_audio player
      player.setLoopMode(newLoopMode);

      emit(state.copyWith(isRepeating: newRepeating));
    });
  }
}
