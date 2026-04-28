import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'data/sources/api_service.dart';
import 'data/repositories/surah_repository.dart';
import 'logic/search_bloc/search_bloc.dart';
// import 'logic/player_bloc/player_bloc.dart'; // Buka ini nanti kalau file PlayerBloc sudah dibuat

final sl = GetIt.instance;

void init() {
  // 1. SERVICES
  sl.registerLazySingleton(() => ApiService());
  sl.registerLazySingleton(() => AudioPlayer());

  // 2. REPOSITORIES
  sl.registerLazySingleton(() => SurahRepository(sl()));

  // 3. BLOCS (INI YANG TADI KURANG)
  // Kita pakai registerFactory karena Bloc harus di-create ulang setiap dipanggil
  sl.registerFactory(() => SearchBloc(sl()));

  // Kalau PlayerBloc-mu sudah ada filenya, daftarkan juga di sini:
  // sl.registerFactory(() => PlayerBloc(sl(), sl()));
}
