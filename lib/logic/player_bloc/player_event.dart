abstract class PlayerEvent {}

class PlaySurah extends PlayerEvent {
  final int surahNumber;
  PlaySurah(this.surahNumber);
}

class TogglePlay extends PlayerEvent {}

class UpdatePosition extends PlayerEvent {
  final Duration position;
  final Duration duration;
  UpdatePosition(this.position, this.duration);
}

class Seek extends PlayerEvent {
  final Duration position;
  Seek(this.position);
}

class NextSurah extends PlayerEvent {}

class PreviousSurah extends PlayerEvent {}

class ToggleRepeat extends PlayerEvent {}
