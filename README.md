# DictionaryDox

A modern Flutter vocabulary trainer app built with Clean Architecture.

## Features

- **Unit Management**: Create and organize vocabulary into units
- **Word Management**: Add words with English-Uzbek translations
- **Word Validation**: Validate English words using Dictionary API
- **Pronunciation**: 
  - Fetch phonetic notation from Dictionary API
  - Play audio pronunciation (when available)
  - Fallback to Text-to-Speech
- **Image Search**: Search and attach images from Pexels
- **Multiple Quiz Types**:
  - Translation Quiz: Build word from letter tiles
  - Image Quiz: Match word to correct image
  - Listening Quiz: Listen and build word from letters
- **Offline Support**: All data stored locally with Hive

## Architecture

The app follows Clean Architecture principles:

```
lib/
├── main.dart
└── src/
    ├── config/           # App configuration (theme, routes, constants)
    ├── core/             # Core utilities (errors, network)
    ├── data/             # Data layer
    │   ├── datasources/  # Local (Hive) and Remote (API) data sources
    │   ├── models/       # Data models with Hive adapters
    │   └── repositories/ # Repository implementations
    ├── domain/           # Domain layer
    │   ├── entities/     # Business entities
    │   ├── repositories/ # Repository interfaces
    │   └── usecases/     # Business logic use cases
    └── presentation/     # Presentation layer
        ├── blocs/        # BLoC state management
        ├── pages/        # UI screens
        └── widgets/      # Reusable widgets
```

## Tech Stack

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **HTTP Client**: dio
- **Local Storage**: hive, hive_flutter
- **Audio**: audioplayers, flutter_tts
- **Images**: cached_network_image
- **Routing**: go_router

## Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Configure API keys:
   - Open `lib/src/data/datasources/remote/pexels_remote_datasource.dart`
   - Replace `YOUR_PEXELS_API_KEY` with your Pexels API key from https://www.pexels.com/api/

5. Run the app:
   ```bash
   flutter run
   ```

## Usage

### Creating a Unit
1. Tap the "+" button on the home screen
2. Enter a unit name and optionally select an icon
3. Tap "Create Unit"

### Adding Words
1. Open a unit
2. Tap the "+" button
3. Enter an English word and tap "Validate Word"
4. If valid, choose optional features:
   - Include pronunciation (phonetic + audio)
   - Add image (opens Pexels search)
   - Add example sentence
5. Enter Uzbek translation
6. Tap "Save Word"

### Taking a Quiz
1. Open a unit
2. Tap "Start Quiz"
3. Select quiz type:
   - **Translation**: See Uzbek translation, build English word
   - **Image**: See English word, select correct image
   - **Listening**: Hear pronunciation, build English word
4. Complete all questions to see your score

## APIs Used

- **Dictionary API**: https://dictionaryapi.dev/
  - Free, no API key required
  - Provides word validation, phonetics, definitions
  
- **Pexels API**: https://www.pexels.com/api/
  - Free tier: 200 requests/hour
  - Provides high-quality stock photos

## License

This project is provided as-is for educational purposes.
