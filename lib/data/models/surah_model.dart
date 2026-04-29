// File: lib/data/models/surah_model.dart

/// Model data untuk Surah (bab) Al-Quran yang diambil dari API AlQuran.cloud.
class SurahModel {
  final int number; // Nomor surah (1-114)
  final String name; // Nama surah dalam tulisan Arab
  final String englishName; // Nama surah dalam bahasa Inggris
  final String
  englishNameTranslation; // Terjemahan nama surah ke bahasa Inggris
  final int numberOfAyahs; // Jumlah ayat dalam surah
  final String revelationType; // Jenis wahyu: Meccan atau Medinan
  final List<AyahModel>?
  ayahs; // List ayat beserta audio (null jika hanya list surah)

  const SurahModel({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    this.ayahs,
  });

  /// Factory constructor untuk mengubah JSON response API menjadi SurahModel.
  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      number: json['number'] as int,
      name: json['name'] as String,
      englishName: json['englishName'] as String,
      englishNameTranslation: json['englishNameTranslation'] as String,
      numberOfAyahs: json['numberOfAyahs'] as int,
      revelationType: json['revelationType'] as String,
      // Mapping ayat hanya jika ada di response (khusus endpoint detail)
      ayahs: json['ayahs'] != null
          ? (json['ayahs'] as List<dynamic>)
                .map((i) => AyahModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

/// Model data untuk satu Ayat (Ayah) beserta audio recitation-nya.
class AyahModel {
  final int number; // Nomor ayat dalam surah tersebut
  final String audio; // URL audio recitation ayat
  final String text; // Teks ayat Al-Quran (Arab)

  const AyahModel({
    required this.number,
    required this.audio,
    required this.text,
  });

  /// Factory constructor untuk mengubah JSON menjadi AyahModel.
  factory AyahModel.fromJson(Map<String, dynamic> json) {
    return AyahModel(
      number: json['number'] as int,
      audio: json['audio'] as String,
      text: json['text'] as String,
    );
  }
}
