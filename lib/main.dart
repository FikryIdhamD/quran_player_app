import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_colors.dart';

void main() {
  runApp(const QuranPlayerApp());
}

class QuranPlayerApp extends StatelessWidget {
  const QuranPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.black,
        primaryColor: AppColors.green,
        // Menggunakan font modern mirip Spotify
        textTheme: GoogleFonts.figtreeTextTheme(ThemeData.dark().textTheme),
      ),
      home: const Scaffold(
        body: Center(
          child: Text(
            'Fase 1: Infrastructure Ready (Branch: dev)',
            style: TextStyle(
              color: AppColors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
