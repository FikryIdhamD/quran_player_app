// File: lib/presentation/widgets/mini_player.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';
import '../../logic/player_bloc/player_state.dart';
import '../screens/player_detail_screen.dart';

/// MiniPlayer adalah widget persisten di bagian bawah layar.
///
/// Widget ini berfungsi sebagai "now playing bar" yang selalu terlihat saat ada surah yang sedang diputar.
/// Fitur utama:
/// - Menampilkan nama surah, qari (Alafasy), dan progress bar
/// - Tombol play/pause
/// - Bisa di-tap untuk membuka layar pemutar penuh (PlayerDetailScreen)
/// - Menggunakan BlocBuilder agar selalu sinkron dengan state PlayerBloc secara real-time
///
/// Desain mengadopsi gaya Spotify mini player agar user experience modern dan familiar.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        // Jika belum ada surah yang diputar, widget ini tidak ditampilkan
        if (state.currentSurah == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            // Navigasi ke layar pemutar penuh
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerDetailScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardGrey,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Tinggi widget mengikuti konten
              children: [
                // Bagian utama: ListTile dengan info surah dan kontrol
                ListTile(
                  dense:
                      true, // Membuat tampilan lebih compact agar tidak overflow
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      color: AppColors.green,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.music_note,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                  title: Text(
                    state.currentSurah!.englishName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  subtitle: const Text(
                    "Alafasy", // Nama qari yang digunakan
                    style: TextStyle(fontSize: 12, color: AppColors.lightGrey),
                  ),
                  trailing: state.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.green,
                          ),
                        )
                      : IconButton(
                          icon: Icon(
                            state.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 28,
                          ),
                          onPressed: () =>
                              context.read<PlayerBloc>().add(TogglePlay()),
                        ),
                ),

                // Progress bar di bawah ListTile
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: LinearProgressIndicator(
                    value: state.duration.inSeconds > 0
                        ? state.position.inSeconds / state.duration.inSeconds
                        : 0,
                    backgroundColor: Colors.white10,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                    minHeight: 2,
                  ),
                ),
                const SizedBox(height: 4), // Jarak kecil di bagian bawah
              ],
            ),
          ),
        );
      },
    );
  }
}
