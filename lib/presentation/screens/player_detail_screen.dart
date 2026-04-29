// File: lib/presentation/screens/player_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import '../../core/theme/app_colors.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';
import '../../logic/player_bloc/player_state.dart';

/// PlayerDetailScreen adalah layar pemutar penuh (full-screen player).
///
/// Layar ini muncul ketika user men-tap MiniPlayer di HomeScreen.
/// Fitur utama:
/// - Artwork besar dengan efek shadow hijau Spotify
/// - Metadata surah (judul + nama qari)
/// - Tombol favorite yang terhubung ke FavoriteCubit
/// - Progress bar interaktif menggunakan package audio_video_progress_bar
/// - Kontrol lengkap: Shuffle, Previous, Play/Pause, Next, Repeat
///
/// Menggunakan BlocBuilder<PlayerBloc> agar seluruh UI selalu update secara real-time
/// sesuai state pemutaran. Desain mengadopsi gaya Spotify full player untuk UX premium.
class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparan agar terlihat modern
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Now Playing",
          style: TextStyle(fontSize: 14, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 50.0),
          child: BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, state) {
              // Jika belum ada surah yang diputar, tampilkan layar kosong
              if (state.currentSurah == null) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ==================== 1. ARTWORK ====================
                    // Placeholder artwork
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth:
                              450, // ← Ubah sesuai selera (280 - 340 paling bagus)
                          maxHeight: 450,
                        ),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.cardGrey,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.green.withOpacity(0.2),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.music_note,
                              size: 100,
                              color: AppColors.green,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),

                    // ==================== 2. METADATA + FAVORITE ====================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.currentSurah!.englishName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Text(
                                "Mishary Rashid Alafasy", // Nama qari tetap (sesuai endpoint)
                                style: TextStyle(
                                  color: AppColors.lightGrey,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tombol Favorite yang reaktif
                        BlocBuilder<FavoriteCubit, List<int>>(
                          builder: (context, favorites) {
                            final isFavorite = favorites.contains(
                              state.currentSurah!.number,
                            );

                            return IconButton(
                              icon: Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isFavorite
                                    ? Colors.red
                                    : AppColors.lightGrey,
                                size: 32,
                              ),
                              onPressed: () {
                                context.read<FavoriteCubit>().toggleFavorite(
                                  state.currentSurah!.number,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // ==================== 3. PROGRESS BAR ====================
                    // Menggunakan package audio_video_progress_bar untuk tampilan yang lebih cantik
                    ProgressBar(
                      progress: state.position,
                      total: state.duration,
                      progressBarColor: AppColors.green,
                      baseBarColor: Colors.white10,
                      thumbColor: AppColors.green,
                      bufferedBarColor: Colors.white24,
                      timeLabelTextStyle: const TextStyle(
                        color: AppColors.lightGrey,
                        fontSize: 12,
                      ),
                      onSeek: (duration) {
                        context.read<PlayerBloc>().add(Seek(duration));
                      },
                    ),
                    const SizedBox(height: 24),

                    // ==================== 4. PLAYER CONTROLS ====================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Shuffle Button
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            size: 32,
                            color: state.isShuffling
                                ? AppColors.green
                                : AppColors.lightGrey,
                          ),
                          onPressed: () =>
                              context.read<PlayerBloc>().add(ToggleShuffle()),
                        ),

                        // Previous Button
                        IconButton(
                          icon: const Icon(Icons.skip_previous, size: 42),
                          color: AppColors.lightGrey,
                          onPressed: () =>
                              context.read<PlayerBloc>().add(PreviousSurah()),
                        ),

                        // Play/Pause Button (besar dan menonjol)
                        GestureDetector(
                          onTap: () =>
                              context.read<PlayerBloc>().add(TogglePlay()),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              state.isPlaying ? Icons.pause : Icons.play_arrow,
                              size: 42,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        // Next Button
                        IconButton(
                          icon: const Icon(Icons.skip_next, size: 42),
                          color: AppColors.lightGrey,
                          onPressed: () =>
                              context.read<PlayerBloc>().add(NextSurah()),
                        ),

                        // Repeat Button
                        IconButton(
                          icon: Icon(
                            Icons.repeat,
                            size: 32,
                            color: state.isRepeating
                                ? AppColors.green
                                : AppColors.lightGrey,
                          ),
                          onPressed: () =>
                              context.read<PlayerBloc>().add(ToggleRepeat()),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
