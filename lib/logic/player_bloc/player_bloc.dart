// File: lib/logic/player_bloc/player_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import 'player_event.dart';
import 'player_state.dart';
import 'dart:math';
import '../../data/repositories/surah_repository.dart';
import '../../data/services/audio_handler.dart';

/// PlayerBloc adalah pusat pengelolaan seluruh logika pemutaran audio Al-Quran.
///
/// Menggunakan BLoC pattern untuk memisahkan business logic dari UI.
/// Bertanggung jawab atas:
/// - Memuat detail surah + audio dari repository
/// - Mengatur playlist ayat menggunakan just_audio
/// - Menangani play, pause, seek, next, previous, repeat, dan shuffle
/// - Update posisi pemutaran secara real-time
///
/// Semua perubahan state dilakukan melalui event agar UI tetap reaktif dan mudah di-test.
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final SurahRepository repository;
  final AudioPlayer player;

  PlayerBloc(this.repository, this.player) : super(const PlayerState()) {
    final audioHandler = AudioHandler(player);

    // Listener untuk update posisi pemutaran secara real-time
    // Dipakai untuk menggerakkan progress bar di MiniPlayer & PlayerDetailScreen
    player.positionStream.listen((pos) {
      add(UpdatePosition(pos, player.duration ?? Duration.zero));
    });

    // Listener untuk mendeteksi ketika satu ayat selesai diputar
    // Otomatis memanggil NextSurah saat audio mencapai akhir
    player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        add(NextSurah());
      }
    });

    /// Event: Memutar surah baru (dipanggil dari SurahTile atau favorit)
    on<PlaySurah>((event, emit) async {
      await player.pause(); // Pause dulu untuk menghindari overlap
      player.setLoopMode(LoopMode.off); // Reset loop mode
      player.setShuffleModeEnabled(false); // Reset shuffle mode

      emit(state.copyWith(isLoading: true)); // Tampilkan loading di UI

      try {
        // Ambil detail surah beserta semua ayat dan URL audio-nya
        final detail = await repository.getSurahDetail(event.surahNumber);

        // Siapkan playlist ayat menggunakan ConcatenatingAudioSource
        await audioHandler.setSurahPlaylist(detail);

        // Mulai memutar audio
        player.play();

        // Update state setelah audio mulai diputar
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

    /// Event: Toggle antara play dan pause
    on<TogglePlay>((event, emit) {
      if (player.playing) {
        player.pause();
        emit(state.copyWith(isPlaying: false));
      } else {
        player.play();
        emit(state.copyWith(isPlaying: true));
      }
    });

    /// Event: Update posisi dan durasi (dipanggil otomatis dari positionStream)
    on<UpdatePosition>((event, emit) {
      emit(state.copyWith(position: event.position, duration: event.duration));
    });

    /// Event: Seek ke posisi tertentu (drag progress bar)
    on<Seek>((event, emit) {
      player.seek(event.position);
    });

    /// Event: Next surah (dipanggil otomatis saat selesai atau manual)
    on<NextSurah>((event, emit) {
      if (state.currentSurah == null) return;

      if (state.isRepeating) {
        // Mode repeat: ulang surah yang sama dari awal
        player.seek(Duration.zero);
        if (!player.playing) player.play();
      } else if (state.isShuffling) {
        // Mode shuffle: pilih surah acak (kecuali surah saat ini)
        int nextNumber;
        do {
          nextNumber = Random().nextInt(114) + 1;
        } while (nextNumber == state.currentSurah!.number);
        add(PlaySurah(nextNumber));
      } else {
        // Next surah secara urut (loop dari 114 kembali ke 1)
        int nextNumber = state.currentSurah!.number + 1;
        if (nextNumber > 114) nextNumber = 1;
        add(PlaySurah(nextNumber));
      }
    });

    /// Event: Previous surah
    on<PreviousSurah>((event, emit) {
      if (state.currentSurah == null) return;

      int prevNumber;
      if (state.isShuffling) {
        // Shuffle mode: previous juga acak
        do {
          prevNumber = Random().nextInt(114) + 1;
        } while (prevNumber == state.currentSurah!.number);
      } else {
        // Previous surah secara urut (loop dari 1 ke 114)
        prevNumber = state.currentSurah!.number - 1;
        if (prevNumber < 1) prevNumber = 114;
      }
      add(PlaySurah(prevNumber));
    });

    /// Event: Toggle mode repeat (mengulang surah saat ini)
    on<ToggleRepeat>((event, emit) {
      if (state.currentSurah == null) return;

      final newRepeating = !state.isRepeating;
      final newLoopMode = newRepeating ? LoopMode.all : LoopMode.off;

      player.setLoopMode(newLoopMode);
      emit(state.copyWith(isRepeating: newRepeating));
    });

    /// Event: Toggle mode shuffle antar surah
    on<ToggleShuffle>((event, emit) {
      if (state.currentSurah == null) return;
      final newValue = !state.isShuffling;
      emit(state.copyWith(isShuffling: newValue));
    });
  }
}
