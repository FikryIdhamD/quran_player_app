abstract class SearchEvent {}

class FetchSurahList extends SearchEvent {}

class FilterSurah extends SearchEvent {
  final String query;
  FilterSurah(this.query);
}
