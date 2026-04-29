// File: lib/logic/search_bloc/search_event.dart

/// Base class untuk semua event SearchBloc.
abstract class SearchEvent {}

/// Event untuk memuat daftar lengkap 114 surah dari API.
/// Dipanggil sekali di awal aplikasi.
class FetchSurahList extends SearchEvent {}

/// Event untuk filter daftar surah secara real-time berdasarkan input user.
class FilterSurah extends SearchEvent {
  final String query; // Kata kunci pencarian (biasanya nama surah Inggris)

  FilterSurah(this.query);
}
