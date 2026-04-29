// File: lib/logic/player_bloc/player_state.dart

import 'package:equatable/equatable.dart';
import '../../data/models/surah_model.dart';

/// Immutable state untuk PlayerBloc.
/// Menggunakan Equatable agar perbandingan state efisien dan UI tidak rebuild berulang.
class PlayerState extends Equatable {
  /// Surah yang sedang aktif diputar (null jika belum ada)
  final SurahModel? currentSurah;

  /// Apakah audio sedang diputar
  final bool isPlaying;

  /// Posisi saat ini (untuk progress bar)
  final Duration position;

  /// Total durasi surah yang sedang diputar
  final Duration duration;

  /// Loading state saat mengambil detail surah dari API
  final bool isLoading;

  /// Mode repeat aktif (mengulang surah saat ini)
  final bool isRepeating;

  /// Mode shuffle aktif (acak antar surah)
  final bool isShuffling;

  const PlayerState({
    this.currentSurah,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
    this.isRepeating = false,
    this.isShuffling = false,
  });

  /// Membuat copy state baru dengan perubahan tertentu (immutable pattern).
  /// Digunakan agar state tidak berubah secara langsung.
  PlayerState copyWith({
    SurahModel? currentSurah,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
    bool? isRepeating,
    bool? isShuffling,
  }) {
    return PlayerState(
      currentSurah: currentSurah ?? this.currentSurah,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
      isRepeating: isRepeating ?? this.isRepeating,
      isShuffling: isShuffling ?? this.isShuffling,
    );
  }

  @override
  List<Object?> get props => [
    currentSurah,
    isPlaying,
    position,
    duration,
    isLoading,
    isRepeating,
    isShuffling,
  ];
}
