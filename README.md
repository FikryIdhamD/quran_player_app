# Quran Player

**A modern Quran audio player built with Flutter** using the public [AlQuran.cloud API](https://alquran.cloud).

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

- Browse all 114 Surahs with English names and revelation info
- **Real-time search** by surah English name
- Full audio playback (play, pause, next, previous)
- Shuffle and Repeat mode
- **Mini Player** (persistent at bottom – Spotify style)
- **Full-screen Player** with beautiful progress bar
- Add/remove favorite surahs (saved locally)
- Dark theme with Spotify-inspired design
- Smooth progress bar with seeking support
- Concatenated playlist per surah (all ayahs play continuously)

## 🛠 Tech Stack

- **Flutter** (latest stable)
- **BLoC** – State management (PlayerBloc, SearchBloc, FavoriteCubit)
- **just_audio** – Audio playback with playlist support
- **Dio** – HTTP client + logging
- **audio_video_progress_bar** – Beautiful progress bar
- **GetIt** – Dependency Injection
- **SharedPreferences** – Local favorite storage
- **Google Fonts (Figtree)** – Modern typography

## 📁 Project Structure

lib/
├── core/theme/              → AppColors & theme constants
├── data/
│   ├── models/              → SurahModel & AyahModel
│   ├── repositories/        → SurahRepository
│   └── sources/             → ApiService (Dio)
├── logic/
│   ├── favorite_cubit/      → Favorite management
│   ├── player_bloc/         → Full audio logic
│   └── search_bloc/         → Search & list management
├── presentation/
│   ├── screens/             → HomeScreen & PlayerDetailScreen
│   └── widgets/             → MiniPlayer & SurahTile
├── injection.dart           → GetIt setup
└── main.dart

## 🚀 How to Run

1. Clone the repository
2. Run `flutter pub get`
3. Run `flutter run`

**Note:** Make sure you have internet connection because audio is streamed from AlQuran.cloud.

## 📡 API Used

- Base URL: `https://api.alquran.cloud/v1/`
- Endpoint list surah: `/surah`
- Endpoint detail + audio: `/surah/{number}/ar.alafasy`

## 📸 Screenshots

*(Tambahkan screenshot atau screen recording di sini nanti)*

- Home Screen with search & favorites
- Mini Player
- Full Player Screen
- Playing state with progress bar

## 🧪 Bonus Implemented

- Comprehensive code comments on every important line
- Clean Architecture + Repository Pattern
- Proper error handling & loading states
- Optimized BlocBuilder with `buildWhen`
- Persistent mini player using Stack + Align

## 📝 Author

**Your Name**  
Technical Test Submission – April 2026