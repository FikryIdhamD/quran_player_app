import '../../data/models/surah_model.dart';

abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SurahModel> allSurah;
  final List<SurahModel> filteredSurah;
  SearchLoaded({required this.allSurah, required this.filteredSurah});
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
}
