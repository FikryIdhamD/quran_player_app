class SurahModel {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final List<AyahModel>? ayahs;

  SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.ayahs,
  });

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'],
      name: json['name'],
      englishName: json['englishName'],
      englishNameTranslation: json['englishNameTranslation'],
      numberOfAyahs: json['numberOfAyahs'],
      revelationType: json['revelationType'],
      ayahs: json['ayahs'] != null
          ? (json['ayahs'] as List).map((i) => AyahModel.fromJson(i)).toList()
          : null,
    );
  }
}

class AyahModel {
  final int number;
  final String audio;
  final String text;

  AyahModel({required this.number, required this.audio, required this.text});

  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'],
      audio: json['audio'],
      text: json['text'],
    );
  }
}
