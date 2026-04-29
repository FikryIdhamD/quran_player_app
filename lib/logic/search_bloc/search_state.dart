// File: lib/logic/search_bloc/search_state.dart

import '../../data/models/surah_model.dart';

/// Base class untuk semua state di SearchBloc.
abstract class SearchState {}

/// State awal sebelum data surah dimuat.
class SearchInitial extends SearchState {}

/// State saat sedang mengambil data dari API.
class SearchLoading extends SearchState {}

/// State berhasil dimuat. Menyimpan dua list:
/// - allSurah → data asli (untuk referensi filter)
/// - filteredSurah → hasil pencarian yang ditampilkan di UI
class SearchLoaded extends SearchState {
  final List<SurahModel> allSurah;
  final List<SurahModel> filteredSurah;

  SearchLoaded({required this.allSurah, required this.filteredSurah});
}

/// State ketika terjadi error saat fetch data surah.
class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
