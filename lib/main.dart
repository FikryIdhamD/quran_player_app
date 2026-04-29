// File: lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_colors.dart';
import 'injection.dart' as di;
import 'logic/favorite_cubit/favorite_cubit.dart';
import 'logic/player_bloc/player_bloc.dart';
import 'logic/search_bloc/search_bloc.dart';
import 'presentation/screens/home_screen.dart';

/// Entry point aplikasi.
void main() async {
  // Pastikan binding Flutter siap sebelum menjalankan async operation
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi semua dependency injection
  di.init();
  await GoogleFonts.pendingFonts();
  runApp(const QuranPlayerApp());
}

/// Root widget aplikasi Quran Player.
class QuranPlayerApp extends StatelessWidget {
  const QuranPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // SearchBloc + langsung fetch daftar surah saat aplikasi mulai
        BlocProvider(create: (context) => di.sl<SearchBloc>()),

        // PlayerBloc untuk mengelola pemutaran audio
        BlocProvider(create: (context) => di.sl<PlayerBloc>()),

        // FavoriteCubit untuk mengelola surah favorit
        BlocProvider(create: (_) => FavoriteCubit()),
      ],
      child: MaterialApp(
        title: 'Quran Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.black,
          primaryColor: AppColors.green,
          // Menggunakan Google Fonts Figtree untuk tampilan modern
          textTheme: GoogleFonts.figtreeTextTheme(ThemeData.dark().textTheme),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
