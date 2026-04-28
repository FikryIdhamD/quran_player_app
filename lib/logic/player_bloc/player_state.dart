import 'package:equatable/equatable.dart';
import '../../data/models/surah_model.dart';

class PlayerState extends Equatable {
  final SurahModel? currentSurah;
  final bool isPlaying;
  final Duration position;
  final Duration duration;
  final bool isLoading;

  const PlayerState({
    this.currentSurah,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.isLoading = false,
  });

  PlayerState copyWith({
    SurahModel? currentSurah,
    bool? isPlaying,
    Duration? position,
    Duration? duration,
    bool? isLoading,
  }) {
    return PlayerState(
      currentSurah: currentSurah ?? this.currentSurah,
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    currentSurah,
    isPlaying,
    position,
    duration,
    isLoading,
  ];
}
