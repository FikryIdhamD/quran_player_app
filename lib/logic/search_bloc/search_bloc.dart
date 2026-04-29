// File: lib/logic/search_bloc/search_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../data/repositories/surah_repository.dart';

/// SearchBloc bertanggung jawab untuk:
/// - Mengambil daftar semua surah (114 surah) dari API
/// - Melakukan pencarian/filter secara client-side
/// - Menyimpan state "allSurah" sebagai referensi dan "filteredSurah" untuk tampilan
///
/// Menggunakan BLoC agar pencarian tetap cepat dan UI reaktif.
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SurahRepository repository;

  SearchBloc(this.repository) : super(SearchInitial()) {
    /// Event: Load semua surah saat aplikasi pertama kali dibuka
    on<FetchSurahList>((event, emit) async {
      emit(SearchLoading());

      try {
        final surahs = await repository.getSurahList();
        emit(SearchLoaded(allSurah: surahs, filteredSurah: surahs));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    });

    /// Event: Filter surah berdasarkan teks yang diketik user
    /// Pencarian dilakukan di client-side untuk performa yang lebih cepat
    on<FilterSurah>((event, emit) {
      if (state is SearchLoaded) {
        final currentState = state as SearchLoaded;

        final filtered = currentState.allSurah
            .where(
              (s) => s.englishName.toLowerCase().contains(
                event.query.toLowerCase(),
              ),
            )
            .toList();

        emit(
          SearchLoaded(
            allSurah: currentState.allSurah, // tetap simpan data asli
            filteredSurah: filtered,
          ),
        );
      }
    });
  }
}
