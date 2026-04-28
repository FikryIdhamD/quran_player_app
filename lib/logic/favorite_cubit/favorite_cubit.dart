import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteCubit extends Cubit<List<int>> {
  FavoriteCubit() : super([]) {
    loadFavorites(); // Otomatis load saat aplikasi jalan
  }

  static const String _key = 'favorite_surahs';

  // Mengambil data dari Shared Preferences
  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favStringList = prefs.getStringList(_key) ?? [];
    // Convert dari String ke Int
    final favList = favStringList.map((e) => int.parse(e)).toList();
    emit(favList);
  }

  // Menambahkan atau menghapus favorite
  Future<void> toggleFavorite(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();
    List<int> currentFavs = List.from(state);

    if (currentFavs.contains(surahNumber)) {
      currentFavs.remove(surahNumber); // Hapus kalau udah ada
    } else {
      currentFavs.add(surahNumber); // Tambah kalau belum ada
    }

    // Simpan kembali ke Shared Preferences
    await prefs.setStringList(
      _key,
      currentFavs.map((e) => e.toString()).toList(),
    );
    emit(currentFavs); // Update UI
  }
}
