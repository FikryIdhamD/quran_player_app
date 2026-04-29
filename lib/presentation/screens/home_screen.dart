// File: lib/presentation/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/app_colors.dart';
import '../../data/models/surah_model.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart';
import '../../logic/search_bloc/search_bloc.dart';
import '../../logic/search_bloc/search_event.dart';
import '../../logic/search_bloc/search_state.dart';
import '../widgets/mini_player.dart';
import '../widgets/surah_tile.dart';

/// HomeScreen adalah layar utama aplikasi Quran Player.
///
/// Menggunakan CustomScrollView + Sliver untuk tampilan modern seperti Spotify.
/// Fitur utama:
/// - Header besar "Quran Player"
/// - Search bar real-time yang terhubung ke SearchBloc
/// - Daftar surah yang terbagi menjadi 2 section: **Favorites** (di atas) dan **All Surahs**
/// - MiniPlayer yang selalu muncul di bagian bawah
/// - Menggabungkan dua BLoC (SearchBloc + FavoriteCubit) untuk menampilkan data secara efisien
///
/// Desain ini memberikan pengalaman pengguna yang cepat, responsif, dan mudah dinavigasi.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch data setelah UI pertama kali muncul
    context.read<SearchBloc>().add(FetchSurahList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // CustomScrollView agar bisa menggunakan Sliver (header, search, list)
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ==================== HEADER ====================
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Quran Player",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // ==================== SEARCH BAR ====================
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (query) {
                        // Kirim event filter ke SearchBloc setiap kali user mengetik
                        context.read<SearchBloc>().add(FilterSurah(query));
                      },
                      decoration: InputDecoration(
                        hintText: "Search Surah...",
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                        fillColor: Colors.white10,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                // ==================== DAFTAR SURAH ====================
                // BlocBuilder SearchBloc untuk menangani loading, error, dan data
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    // Loading state
                    if (searchState is SearchLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.green,
                          ),
                        ),
                      );
                    }

                    // Error state dengan tombol retry
                    if (searchState is SearchError) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.wifi_off,
                                size: 120,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "Periksa kembali koneksi internet Anda.",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<SearchBloc>().add(
                                    FetchSurahList(),
                                  );
                                },
                                icon: const Icon(Icons.refresh),
                                label: const Text("Coba Lagi"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.green,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Jika tidak ada data atau filter kosong
                    if (searchState is! SearchLoaded ||
                        searchState.filteredSurah.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }

                    final allSurahs = searchState.filteredSurah;

                    // BlocBuilder FavoriteCubit hanya rebuild saat daftar favorite benar-benar berubah
                    return BlocBuilder<FavoriteCubit, List<int>>(
                      buildWhen: (previous, current) =>
                          previous.length != current.length ||
                          !previous.toSet().containsAll(current) ||
                          !current.toSet().containsAll(previous),
                      builder: (context, favorites) {
                        // Pisahkan surah favorit dan non-favorit
                        final favoriteSurahs = allSurahs
                            .where((s) => favorites.contains(s.number))
                            .toList();
                        final otherSurahs = allSurahs
                            .where((s) => !favorites.contains(s.number))
                            .toList();

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // ====================== SECTION FAVORITES ======================
                              if (favoriteSurahs.isNotEmpty) {
                                // Header Favorites
                                if (index == 0) {
                                  return _buildSectionHeader("Favorites");
                                }
                                // Item surah favorit
                                if (index <= favoriteSurahs.length) {
                                  return SurahTile(
                                    surah: favoriteSurahs[index - 1],
                                  );
                                }
                              }

                              // ====================== SECTION ALL SURAHS ======================
                              final allStartIndex = favoriteSurahs.isNotEmpty
                                  ? favoriteSurahs.length + 1
                                  : 0;

                              // Header All Surahs
                              if (index == allStartIndex) {
                                return _buildSectionHeader("All Surahs");
                              }

                              // Item surah biasa
                              final remainingIndex = index - allStartIndex - 1;
                              if (remainingIndex < otherSurahs.length) {
                                return SurahTile(
                                  surah: otherSurahs[remainingIndex],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                            childCount: _calculateChildCount(
                              favoriteSurahs,
                              otherSurahs,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),

            // MiniPlayer selalu di paling bawah (menggunakan Stack + Align)
            const Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }

  /// Helper untuk membuat header section (Favorites / All Surahs)
  /// Menggunakan warna hijau Spotify agar konsisten dengan tema aplikasi.
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.green,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  /// Menghitung total child yang dibutuhkan di SliverList.
  /// Rumus: (Favorites header + items) + (All Surahs header + items)
  int _calculateChildCount(
    List<SurahModel> favorites,
    List<SurahModel> others,
  ) {
    int count = 0;
    if (favorites.isNotEmpty) {
      count += favorites.length + 1; // header + semua item favorit
    }
    count += others.length + 1; // header + semua item lainnya
    return count;
  }
}
