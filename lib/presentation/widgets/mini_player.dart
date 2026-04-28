import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';
import '../../logic/player_bloc/player_state.dart';
import '../../core/theme/app_colors.dart';
import '../screens/player_detail_screen.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.currentSurah == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () {
            // Navigasi ke halaman Detail
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
              mainAxisSize: MainAxisSize.min, // Biar tingginya pas dengan isi
              children: [
                ListTile(
                  dense:
                      true, // Membuat ListTile lebih ramping agar tidak overflow
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Container(
                      color: AppColors.green,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.music_note, color: Colors.black),
                    ),
                  ),
                  title: Text(
                    state.currentSurah!.englishName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow
                        .ellipsis, // Jika judul kepanjangan tidak overflow
                  ),
                  subtitle: const Text(
                    "Alafasy",
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
                            state.isPlaying ? Icons.pause : Icons.play_arrow,
                          ),
                          onPressed: () =>
                              context.read<PlayerBloc>().add(TogglePlay()),
                        ),
                ),
                // Progress Bar tetap di bawah
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
                const SizedBox(height: 4), // Padding bawah dikit
              ],
            ),
          ),
        );
      },
    );
  }
}
