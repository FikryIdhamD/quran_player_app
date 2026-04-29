// File: lib/presentation/widgets/surah_tile.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/surah_model.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart';
import '../../logic/player_bloc/player_bloc.dart';
import '../../logic/player_bloc/player_event.dart';

/// SurahTile adalah widget reusable untuk menampilkan satu item surah di daftar katalog.
///
/// Digunakan di HomeScreen atau halaman pencarian.
/// Fitur:
/// - Nomor surah di lingkaran (seperti Mushaf)
/// - Nama surah dalam bahasa Inggris
/// - Informasi revelation type + jumlah ayat
/// - Tombol favorite (heart) yang terhubung ke FavoriteCubit
/// - Tap item → langsung memutar surah tersebut via PlayerBloc
///
/// Menggunakan BlocBuilder hanya untuk bagian favorite agar performa tetap optimal.
class SurahTile extends StatelessWidget {
  final SurahModel surah;

  const SurahTile({super.key, required this.surah});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              fontSize: 16,
            ),
          ),
        ),
      ),
      title: Text(
        surah.englishName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
      ),
      subtitle: Text(
        "${surah.revelationType} • ${surah.numberOfAyahs} Ayahs",
        style: const TextStyle(color: AppColors.lightGrey, fontSize: 12),
      ),
      // Bagian trailing: tombol favorite yang reaktif
      trailing: BlocBuilder<FavoriteCubit, List<int>>(
        builder: (context, favorites) {
          final isFavorite = favorites.contains(surah.number);

          return IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : AppColors.lightGrey,
              size: 26,
            ),
            onPressed: () {
              // Toggle favorite melalui FavoriteCubit
              context.read<FavoriteCubit>().toggleFavorite(surah.number);
            },
          );
        },
      ),
      // Ketika item di-tap → putar surah ini
      onTap: () {
        context.read<PlayerBloc>().add(PlaySurah(surah.number));
      },
    );
  }
}
