# LCMTV - Video Streaming App

A modern, YouTube-like video streaming application built with Flutter, featuring a beautiful purple and white theme.

## 🎯 Features

### 📱 Core Features
- **Modern UI/UX** - Clean, professional design with purple and white branding
- **Video Streaming** - YouTube-like video player with full controls
- **User Authentication** - Login, signup, and email verification
- **Content Discovery** - Trending videos, categories, and search
- **User Profiles** - Complete profile management and customization

### 🏠 Home Screen
- **Livestream Hero Section** - Prominent live streaming content
- **Featured Videos** - Curated video recommendations
- **Program Collections** - Organized content by categories
- **Category Filtering** - Easy content discovery

### 📈 Trending Screen
- **Trending Statistics** - Real-time trending data and insights
- **Category Tabs** - Filter trending content by category
- **Modern Video Cards** - Beautiful video cards with rankings
- **Interactive Features** - Like, share, and playlist management

### 🔍 Search & Discovery
- **Advanced Search** - Real-time search with suggestions
- **Category Filters** - Filter by duration, date, popularity
- **Search History** - Track and revisit previous searches

### 👤 Profile Management
- **Edit Profile** - Complete profile customization
- **Watch History** - Track viewing history with progress
- **Liked Videos** - Manage favorite content
- **About Screen** - App information and support

### 🎨 Design System
- **Purple Branding** - Consistent purple and white theme
- **Material 3** - Modern Material Design components
- **Responsive Layout** - Works on all screen sizes
- **Smooth Animations** - Professional micro-interactions

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: BLoC Pattern
- **Navigation**: GoRouter
- **Video Player**: youtube_player_flutter
- **HTTP Client**: Dio with Retrofit
- **Local Storage**: Hive
- **Authentication**: Firebase Auth
- **UI Components**: Material 3

## 📦 Dependencies

### Core Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5
  dio: ^5.7.0
  retrofit: ^4.4.1
  json_annotation: ^4.9.0
  youtube_player_flutter: ^9.0.0
  go_router: ^14.6.2
  cached_network_image: ^3.4.1
  shimmer: ^3.0.0
  shared_preferences: ^2.3.2
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  google_sign_in: ^6.2.1
  intl: ^0.19.0
  url_launcher: ^6.3.1
  connectivity_plus: ^6.1.0
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  build_runner: ^2.4.13
  retrofit_generator: ^8.1.0
  json_serializable: ^6.8.0
  hive_generator: ^2.0.1
  bloc_test: ^9.1.7
  mockito: ^5.4.4
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.x or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/lcmtv.git
   cd lcmtv
   ```

2. **Install dependencies**
   ```bash
   cd lcmtv_app
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```

#### Android App Bundle
```bash
flutter build appbundle --release
```

## 📱 Screenshots

### Authentication Flow
- Splash Screen with animated logo
- Onboarding with 3 informative slides
- Login/Signup with modern forms
- Email verification process

### Main App
- Home screen with livestream hero
- Trending screen with statistics
- Search with advanced filters
- Profile with complete management

## 🏗️ Project Structure

```
lcmtv_app/
├── lib/
│   ├── core/
│   │   ├── theme/
│   │   └── errors/
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   ├── search/
│   │   ├── trending/
│   │   └── profile/
│   └── shared/
│       └── widgets/
├── test/
├── android/
├── ios/
└── pubspec.yaml
```

## 🎨 Design System

### Color Palette
- **Primary Purple**: #6B46C1
- **Secondary Purple**: #8B5CF6
- **Light Purple**: #A78BFA
- **Background White**: #FFFFFF
- **Light Gray**: #F8F9FA
- **Text Dark**: #1F2937
- **Text Light**: #6B7280

### Typography
- **Headings**: Bold, modern sans-serif
- **Body**: Clean, readable text
- **Captions**: Smaller, subtle text

### Spacing
- **XS**: 4px
- **S**: 8px
- **M**: 16px
- **L**: 24px
- **XL**: 32px
- **XXL**: 48px

## 🧪 Testing

Run tests with:
```bash
flutter test
```

Run integration tests:
```bash
flutter drive --target=test_driver/app.dart
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

- **Email**: support@lcmtv.com
- **Website**: www.lcmtv.com
- **Issues**: [GitHub Issues](https://github.com/yourusername/lcmtv/issues)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for the design system
- YouTube for inspiration
- Open source community

---

**Built with ❤️ using Flutter**