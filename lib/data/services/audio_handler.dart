// File: lib/data/services/audio_handler.dart

import 'package:just_audio/just_audio.dart';
import '../models/surah_model.dart';

/// Service yang mengelola pemutaran audio Al-Quran menggunakan package just_audio.
class AudioHandler {
  final AudioPlayer player;

  AudioHandler(this.player);

  /// Mengatur playlist audio untuk seluruh ayat dalam satu surah.
  /// Menggunakan ConcatenatingAudioSource agar bisa play next/previous dengan mulus.
  Future<void> setSurahPlaylist(SurahModel surah) async {
    if (surah.ayahs == null || surah.ayahs!.isEmpty) {
      throw Exception(
        'Surah ${surah.englishName} tidak memiliki ayat untuk diputar',
      );
    }

    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true, // Memuat audio secara efisien (lazy loading)
      children: surah.ayahs!.map((ayah) {
        return AudioSource.uri(
          Uri.parse(ayah.audio),
          // Tag digunakan untuk metadata di notification & lockscreen
          tag: surah.englishName,
        );
      }).toList(),
    );

    await player.setAudioSource(playlist);
  }
}
