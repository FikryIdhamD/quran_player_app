// File: lib/injection.dart

import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';

import 'data/sources/api_service.dart';
import 'data/repositories/surah_repository.dart';
import 'logic/player_bloc/player_bloc.dart';
import 'logic/search_bloc/search_bloc.dart';

/// Instance global GetIt untuk Dependency Injection di seluruh aplikasi.
final sl = GetIt.instance;

/// Fungsi untuk mendaftarkan semua dependency (service, repository, bloc) ke GetIt.
/// Dipanggil sekali di main.dart sebelum aplikasi dijalankan.
void init() {
  // ====================== SERVICES ======================
  // ApiService untuk HTTP request ke AlQuran.cloud
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // AudioPlayer dari package just_audio
  sl.registerLazySingleton<AudioPlayer>(() => AudioPlayer());

  // ====================== REPOSITORIES ======================
  // Repository yang menghubungkan API dengan business logic
  sl.registerLazySingleton<SurahRepository>(
    () => SurahRepository(sl<ApiService>()),
  );

  // ====================== BLOCS / CUBITS ======================
  // SearchBloc dibuat ulang setiap kali diperlukan (factory)
  sl.registerFactory<SearchBloc>(() => SearchBloc(sl<SurahRepository>()));

  // PlayerBloc juga factory karena harus fresh setiap screen
  sl.registerFactory<PlayerBloc>(
    () => PlayerBloc(sl<SurahRepository>(), sl<AudioPlayer>()),
  );
}
