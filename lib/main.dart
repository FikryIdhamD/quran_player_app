import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';
import 'injection.dart' as di;
import 'logic/search_bloc/search_bloc.dart';
import 'logic/search_bloc/search_event.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  runApp(const QuranPlayerApp());
}

class QuranPlayerApp extends StatelessWidget {
  const QuranPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Mendaftarkan SearchBloc secara Global
        BlocProvider(
          create: (context) => di.sl<SearchBloc>()..add(FetchSurahList()),
        ),
      ],
      child: MaterialApp(
        title: 'Quran Player',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: AppColors.black,
          primaryColor: AppColors.green,
          textTheme: GoogleFonts.figtreeTextTheme(ThemeData.dark().textTheme),
        ),
        home: const HomeScreen(), // Pindah ke halaman Home yang asli
      ),
    );
  }
}
