import '../../data/models/surah_model.dart';

class PlayerState {
  final SurahModel? currentSurah;
  final bool isPlaying;
  final Duration position;
  final Duration duration;

  PlayerState({
    this.currentSurah,
    this.isPlaying = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
  });
}
