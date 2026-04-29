// File: lib/logic/player_bloc/player_event.dart

/// Base class untuk semua event di PlayerBloc.
/// Menggunakan sealed class pattern (abstract) agar event mudah di-extend.
abstract class PlayerEvent {}

/// Meminta PlayerBloc untuk memutar surah berdasarkan nomor surah.
class PlaySurah extends PlayerEvent {
  final int surahNumber;
  PlaySurah(this.surahNumber);
}

/// Toggle antara play dan pause.
class TogglePlay extends PlayerEvent {}

/// Update posisi dan durasi pemutaran (dipanggil otomatis setiap detik).
class UpdatePosition extends PlayerEvent {
  final Duration position;
  final Duration duration;
  UpdatePosition(this.position, this.duration);
}

/// Seek ke posisi waktu tertentu dalam surah.
class Seek extends PlayerEvent {
  final Duration position;
  Seek(this.position);
}

/// Next surah (dipanggil otomatis saat audio selesai atau tombol next).
class NextSurah extends PlayerEvent {}

/// Previous surah.
class PreviousSurah extends PlayerEvent {}

/// Toggle mode repeat (mengulang surah saat ini atau semua surah).
class ToggleRepeat extends PlayerEvent {}

/// Toggle mode shuffle (acak surah saat next/prev).
class ToggleShuffle extends PlayerEvent {}
