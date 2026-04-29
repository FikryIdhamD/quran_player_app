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
- Dark theme with Responsive design
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
```
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
```
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

- Home Screen with search & favorites
  
  <img width="200" alt="Screenshot_20260429_130017" src="https://github.com/user-attachments/assets/744ee730-f8ba-40dd-91ba-70bed342ac5a" />
  
- Mini Player
  
  <img width="400" alt="Screenshot_20260429_130017(1)" src="https://github.com/user-attachments/assets/5809438c-d2ff-4a4c-b6d9-c6e6128ffdda" />

- Full Player Screen
  
  <img width="200" alt="Screenshot_20260429_130027" src="https://github.com/user-attachments/assets/128d1837-ecc6-4cdc-a71b-44056a346c24" />
  
  
- Playing state with progress bar
  
  <img height="200"  alt="Screenshot_20260429_130027(1)" src="https://github.com/user-attachments/assets/21cdcde4-8e28-425c-8b30-2a727e7f879c" />

- Demo Video

  [Demo Aplikasi Quran Player](https://drive.google.com/file/d/1aTFkuSlrJB-3PrDx0vi6YNgKWLKHcI4Y/view?usp=sharing)
  
## 🧪 Bonus Implemented

- Comprehensive code comments on every important line
- Clean Architecture + Repository Pattern
- Proper error handling & loading states
- Optimized BlocBuilder with `buildWhen`
- Persistent mini player using Stack + Align

## 📝 Author

**Fikry Idham D**  
Technical Test Submission – April 2026
