import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/search_bloc/search_bloc.dart';
import '../../logic/search_bloc/search_event.dart';
import '../../logic/search_bloc/search_state.dart';
import '../widgets/surah_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Ala Spotify
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Quran Player",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
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
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
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
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  );
                } else if (state is SearchLoaded) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final surah = state.filteredSurah[index];
                      return SurahTile(surah: surah);
                    }, childCount: state.filteredSurah.length),
                  );
                } else if (state is SearchError) {
                  return SliverFillRemaining(
                    child: Center(child: Text(state.message)),
                  );
                }
                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
