// File: lib/logic/favorite_cubit/favorite_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Cubit untuk mengelola daftar Surah favorit menggunakan SharedPreferences.
/// State berupa List<int> berisi nomor surah yang difavoritkan.
class FavoriteCubit extends Cubit<List<int>> {
  FavoriteCubit() : super([]) {
    // Otomatis memuat data favorit saat Cubit diinisialisasi
    loadFavorites();
  }

  /// Key untuk menyimpan data favorit di SharedPreferences
  static const String _key = 'favorite_surahs';

  /// Memuat daftar surah favorit dari SharedPreferences saat aplikasi dibuka.
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favStringList = prefs.getStringList(_key) ?? [];

    // Konversi List<String> menjadi List<int>
    final favList = favStringList.map((e) => int.parse(e)).toList();

    emit(favList); // Update state agar UI langsung ter-refres
  }

  /// Menambahkan atau menghapus surah dari daftar favorit (toggle).
  Future<void> toggleFavorite(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> currentFavs = List.from(state); // Copy state agar immutable

    if (currentFavs.contains(surahNumber)) {
      currentFavs.remove(surahNumber); // Hapus jika sudah ada
    } else {
      currentFavs.add(surahNumber); // Tambah jika belum ada
    }

    // Simpan kembali ke SharedPreferences dalam bentuk List<String>
    await prefs.setStringList(
      _key,
      currentFavs.map((e) => e.toString()).toList(),
    );

    emit(currentFavs); // Emit state baru agar UI ter-update
  }
}
