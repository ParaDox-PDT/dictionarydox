# DictionaryDox

A modern Flutter vocabulary trainer app built with Clean Architecture. Now available on **Web, iOS, and Android**! 🌐📱

[![Netlify Status](https://api.netlify.com/api/v1/badges/your-badge-id/deploy-status)](https://app.netlify.com/sites/your-site/deploys)

## 🌟 Features

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
- **Cross-Platform Storage**: 
  - Mobile/Desktop: Hive (local database)
  - Web: Local Storage (browser storage)
- **Responsive Design**: Optimized for all screen sizes
- **Splash Screen**: Beautiful animated splash screen

## 🚀 Live Demo

**Web App**: [https://dictionarydox.netlify.app](https://dictionarydox.netlify.app)

## 📱 Platform Support

- ✅ **Web** - Fully optimized with responsive design
- ✅ **Android** - Native Android app
- ✅ **iOS** - Native iOS app
- ✅ **Windows** - Desktop application
- ✅ **macOS** - Desktop application
- ✅ **Linux** - Desktop application

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

## 🛠️ Tech Stack

- **State Management**: flutter_bloc
- **Dependency Injection**: get_it
- **HTTP Client**: dio
- **Local Storage**: 
  - Mobile/Desktop: hive, hive_flutter
  - Web: shared_preferences (Local Storage)
- **Audio**: audioplayers, flutter_tts
- **Images**: cached_network_image
- **Routing**: go_router
- **Platform Detection**: Conditional imports for web/mobile compatibility

## 💻 Setup

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/ParaDox-PDT/dictionarydox.git
   cd dictionarydox
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate Hive adapters (for mobile):
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. Configure API keys:
   - Open `lib/src/data/datasources/remote/pexels_remote_datasource.dart`
   - Replace `YOUR_PEXELS_API_KEY` with your Pexels API key from https://www.pexels.com/api/

5. Run the app:
   ```bash
   # For mobile
   flutter run
   
   # For web
   flutter run -d chrome
   
   # For desktop
   flutter run -d windows  # or macos, linux
   ```

## 🌐 Web Deployment

### Build for Web
```bash
flutter build web --release
```

### Deploy to Netlify

#### Option 1: Netlify CLI (Recommended)
```bash
# Install Netlify CLI
npm install -g netlify-cli

# Login
netlify login

# Deploy
netlify deploy --prod --dir=build/web
```

#### Option 2: PowerShell Script
```bash
./deploy-netlify.ps1
```

#### Option 3: Drag & Drop
1. Go to [Netlify](https://app.netlify.com/)
2. Drag the `build/web` folder

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

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
