import 'package:equatable/equatable.dart';
import '../../data/models/surah_model.dart';

class PlayerState extends Equatable {
  final SurahModel? currentSurah;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;
  final bool isRepeating;
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
