import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/search_bloc/search_bloc.dart';
import '../../logic/search_bloc/search_event.dart';
import '../../logic/search_bloc/search_state.dart';
import '../../logic/favorite_cubit/favorite_cubit.dart'; // Import Cubit Favorite
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

                // Daftar Surah
                BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, searchState) {
                    if (searchState is SearchLoading) {
                      return const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.green),
                        ),
                      );
                    } else if (searchState is SearchLoaded) {
                      return BlocBuilder<FavoriteCubit, List<int>>(
                        builder: (context, favorites) {
                          // 1. Pisahkan surah menjadi dua list
                          final favoriteSurahs = searchState.filteredSurah
                              .where((s) => favorites.contains(s.number))
                              .toList();
                          final otherSurahs = searchState.filteredSurah
                              .where((s) => !favorites.contains(s.number))
                              .toList();

                          // 2. Gabungkan ke dalam satu list dinamis beserta teks Header-nya
                          final List<dynamic> mergedItems = [];

                          if (favoriteSurahs.isNotEmpty) {
                            mergedItems.add(
                              "Favorites",
                            ); // Masukkan String sebagai penanda Header
                            mergedItems.addAll(
                              favoriteSurahs,
                            ); // Masukkan list SurahModel
                          }

                          if (otherSurahs.isNotEmpty) {
                            mergedItems.add(
                              "All Surahs",
                            ); // Masukkan String sebagai penanda Header
                            mergedItems.addAll(
                              otherSurahs,
                            ); // Masukkan list SurahModel
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.only(bottom: 80),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate((
                                context,
                                index,
                              ) {
                                final item = mergedItems[index];

                                // 3. Render UI berdasarkan tipe datanya (Header vs Tile)
                                if (item is String) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 24,
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors
                                            .green, // Sesuaikan dengan AppColors.green lu
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  );
                                }

                                // Jika bukan String, berarti itu adalah SurahModel
                                return SurahTile(surah: item);
                              }, childCount: mergedItems.length),
                            ),
                          );
                        },
                      );
                    } else if (searchState is SearchError) {
                      return SliverFillRemaining(
                        child: Center(child: Text(searchState.message)),
                      );
                    }
                    return const SliverToBoxAdapter(child: SizedBox());
                  },
                ),
              ],
            ),
            const Align(alignment: Alignment.bottomCenter, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
