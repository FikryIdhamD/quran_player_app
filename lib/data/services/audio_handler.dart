import 'package:just_audio/just_audio.dart';
import '../models/surah_model.dart';

class AudioHandler {
  final AudioPlayer player;

  AudioHandler(this.player);

  Future<void> setSurahPlaylist(SurahModel surah) async {
    final playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      children: surah.ayahs!.map((ayah) {
        return AudioSource.uri(
          Uri.parse(ayah.audio),
          tag: surah.englishName, // Judul lagu untuk metadata
        );
      }).toList(),
    );

    await player.setAudioSource(playlist);
  }
}
