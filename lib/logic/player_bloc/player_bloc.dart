import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'player_event.dart';
import 'player_state.dart';
import 'dart:math';
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
      player.setLoopMode(LoopMode.off); // reset dulu
      player.setShuffleModeEnabled(false);
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
      if (state.currentSurah == null) return;

      if (state.isRepeating) {
        player.seek(Duration.zero);
        if (!player.playing) {
          player.play();
        }
        // Tidak perlu emit state baru, position listener sudah otomatis update
      } else if (state.isShuffling) {
        // Shuffle antar surah (tetap seperti sebelumnya)
        int nextNumber;
        do {
          nextNumber = Random().nextInt(114) + 1;
        } while (nextNumber == state.currentSurah!.number);
        add(PlaySurah(nextNumber));
      } else {
        // Next surah biasa (urut)
        int nextNumber = state.currentSurah!.number + 1;
        if (nextNumber > 114) nextNumber = 1; // loop ke awal
        add(PlaySurah(nextNumber));
      }
    });

    on<PreviousSurah>((event, emit) {
      if (state.currentSurah == null) return;

      int prevNumber;
      if (state.isShuffling) {
        // Saat shuffle ON, Previous juga acak (lebih simpel & umum)
        do {
          prevNumber = Random().nextInt(114) + 1;
        } while (prevNumber == state.currentSurah!.number);
      } else {
        prevNumber = state.currentSurah!.number - 1;
        if (prevNumber < 1) prevNumber = 114; // loop ke akhir
      }
      add(PlaySurah(prevNumber));
    });

    on<ToggleRepeat>((event, emit) {
      if (state.currentSurah == null) return;

      final newRepeating = !state.isRepeating;
      final newLoopMode = newRepeating ? LoopMode.all : LoopMode.off;

      // Terapkan ke just_audio player
      player.setLoopMode(newLoopMode);

      emit(state.copyWith(isRepeating: newRepeating));
    });

    on<ToggleShuffle>((event, emit) {
      if (state.currentSurah == null) return;
      final newValue = !state.isShuffling;
      emit(state.copyWith(isShuffling: newValue));
    });
  }
}
