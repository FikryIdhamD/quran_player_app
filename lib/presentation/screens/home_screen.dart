import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/search_bloc/search_bloc.dart';
import '../../logic/search_bloc/search_event.dart';
import '../../logic/search_bloc/search_state.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart';
import '../../core/theme/app_colors.dart'; // ← pastikan import ini ada

import '../widgets/mini_player.dart';
import '../widgets/surah_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header Ala Spotify
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

                // Search Bar
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      onChanged: (query) {
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

                // ==================== DAFTAR SURAH (OPTIMIZED) ====================
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    if (searchState is SearchLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.green,
                          ),
                        ),
                      );
                    }

                    if (searchState is SearchError) {
                      return SliverFillRemaining(
                        child: Center(child: Text(searchState.message)),
                      );
                    }

                    if (searchState is! SearchLoaded ||
                        searchState.filteredSurah.isEmpty) {
                      return const SliverToBoxAdapter(child: SizedBox());
                    }

                    final allSurahs = searchState.filteredSurah;

                    return BlocBuilder<FavoriteCubit, List<int>>(
                      // ✅ Hanya rebuild kalau favorite benar-benar berubah
                      buildWhen: (previous, current) =>
                          previous.length != current.length ||
                          !previous.toSet().containsAll(current) ||
                          !current.toSet().containsAll(previous),
                      builder: (context, favorites) {
                        // Pisahkan daftar
                        final favoriteSurahs = allSurahs
                            .where((s) => favorites.contains(s.number))
                            .toList();
                        final otherSurahs = allSurahs
                            .where((s) => !favorites.contains(s.number))
                            .toList();

                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              // 1. Favorites Section
                              if (favoriteSurahs.isNotEmpty) {
                                if (index == 0) {
                                  return _buildSectionHeader("Favorites");
                                }
                                if (index <= favoriteSurahs.length) {
                                  return SurahTile(
                                    surah: favoriteSurahs[index - 1],
                                  );
                                }
                              }

                              // 2. All Surahs Section
                              final allStartIndex = favoriteSurahs.isNotEmpty
                                  ? favoriteSurahs.length + 1
                                  : 0;

                              if (index == allStartIndex) {
                                return _buildSectionHeader("All Surahs");
                              }

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
              ],
            ),

            // Mini Player tetap di paling bawah
            const Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }

  // Helper method (const-friendly)
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

  // Helper untuk menghitung total item di SliverList
  int _calculateChildCount(List<dynamic> favorites, List<dynamic> others) {
    int count = 0;
    if (favorites.isNotEmpty) count += favorites.length + 1; // header + items
    count += others.length + 1; // header + items
    return count;
  }
}
