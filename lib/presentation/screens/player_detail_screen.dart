import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';
import '../../logic/player_bloc/player_state.dart';
import '../../core/theme/app_colors.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          if (state.currentSurah == null) return const SizedBox();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. ARTWORK (Placeholder Spotify Style)
                AspectRatio(
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
                const SizedBox(height: 48),

                // 3. METADATA (Judul & Artist)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            "Mishary Rashid Alafasy",
                            style: TextStyle(
                              color: AppColors.lightGrey,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // BUNGKUS DENGAN BLOC BUILDER
                    BlocBuilder<FavoriteCubit, List<int>>(
                      builder: (context, favorites) {
                        // Cek apakah surah yang sedang di-play ada di list favorite
                        final isFavorite = favorites.contains(
                          state.currentSurah!.number,
                        );

                        return IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : AppColors.lightGrey,
                            size: 32, // Sedikit dibesarkan biar enak diklik
                          ),
                          onPressed: () {
                            // Jalankan fungsi toggle dari Cubit
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

                // 3. PROGRESS BAR (The Slider)
                ProgressBar(
                  progress: state.position,
                  total: state.duration,
                  progressBarColor: AppColors.green,
                  baseBarColor: Colors.white10,
                  thumbColor: AppColors.green,
                  bufferedBarColor: Colors.white24,
                  timeLabelTextStyle: const TextStyle(
                    color: AppColors.lightGrey,
                  ),
                  onSeek: (duration) {
                    context.read<PlayerBloc>().add(Seek(duration));
                  },
                ),
                const SizedBox(height: 24),

                // 4. CONTROLS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Icon(Icons.shuffle, color: AppColors.lightGrey),
                    const Icon(Icons.skip_previous, size: 42),

                    // PLAY/PAUSE BUTTON
                    GestureDetector(
                      onTap: () => context.read<PlayerBloc>().add(TogglePlay()),
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

                    const Icon(Icons.skip_next, size: 42),
                    const Icon(Icons.repeat, color: AppColors.lightGrey),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
