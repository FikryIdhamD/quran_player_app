# 📖 Quran Music Player (Spotify Style)

A high-performance mobile application built with Flutter that provides a seamless Al-Quran audio listening experience using the Al-Quran Cloud API.

## 🚀 Features

- **Spotify-Inspired UI:** Dark theme with a sleek, modern aesthetic.
- **Dynamic Search:** Instant local filtering for all 114 Surahs.
- **Verse-by-Verse Playback:** Seamlessly merges individual ayahs into a continuous surah stream.
- **Persistent Mini Player:** Control audio while browsing the surah list.
- **Full Player Detail:** Beautiful full-screen player with seeking functionality (Slider).

## 🛠️ Tech Stack

| Component            | Technology                        |
| -------------------- | --------------------------------- |
| **Language**         | Dart (Flutter)                    |
| **State Management** | BLoC (Business Logic Component)   |
| **Networking**       | Dio                               |
| **Audio Engine**     | Just Audio                        |
| **Service Locator**  | GetIt                             |
| **Fonts**            | Google Fonts (Figtree/Montserrat) |

## 🏗️ Architecture

This project follows **Clean Architecture** principles to ensure scalability and maintainability:

- **Data:** Models, Repositories Implementation, API Sources.
- **Domain:** Entities, Repository Interfaces.
- **Logic:** BLoC (Search & Player).
- **Presentation:** Screens & Widgets.

## ⚙️ How to Run

1. Clone this repository.
2. Run `flutter pub get` in the terminal.
3. Run `flutter run`.

## 🧪 Testing

Run the following command to execute unit and widget tests:

```bash
flutter test
```
