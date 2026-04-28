import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/surah_model.dart';
import '../../core/theme/app_colors.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';

class SurahTile extends StatelessWidget {
  final SurahModel surah;
  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            surah.number.toString(),
            style: const TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      title: Text(
        surah.englishName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        "${surah.revelationType} • ${surah.numberOfAyahs} Ayahs",
        style: const TextStyle(color: AppColors.lightGrey, fontSize: 12),
      ),
      trailing: const Icon(Icons.more_vert, color: AppColors.lightGrey),
      onTap: () {
        context.read<PlayerBloc>().add(PlaySurah(surah.number));
      },
    );
  }
}
