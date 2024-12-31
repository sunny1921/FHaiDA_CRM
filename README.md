# FHaiDA CRM

A comprehensive Customer Relationship Management (CRM) system built with Flutter, designed for real estate and property management. This application provides a robust platform for managing leads, properties, tasks, and customer interactions with advanced features like business card scanning and document processing.

## 🌟 Features

### Lead Management
- Create and manage leads
- Track lead status and progress
- Lead profile viewing and editing
- Automated lead status updates

### Property Management
- Comprehensive property listings
- Property details with media support
- Document processing for property data
- Gallery view for property images

### Task Management
- Create and assign tasks
- Task tracking and status updates
- Calendar integration
- Task notifications

### Contact Management
- Business card scanning with OCR
- Contact import from documents
- Social media integration
- Contact organization and categorization

### Additional Features
- Firebase integration for real-time data
- Cloud storage for documents and media
- User authentication and authorization
- Background services for notifications
- Mobile-responsive design

<div align="center">
<iframe width="560" height="315" src="https://www.youtube.com/embed/o9TSi1aqADM?si=jQ6wfvboTW4AUhu1" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
</div>



## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.2.6)
- Dart SDK (>=3.2.6)
- Firebase account
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
```bash
git clone https://github.com/yourusername/FHaiDA_CRM.git
cd FHaiDA_CRM
```

2. Install dependencies
```bash
flutter pub get
```

3. Configure Firebase
- Create a new Firebase project
- Add your Android and iOS apps in Firebase console
- Download and place the configuration files:
  - `google-services.json` for Android
  - `GoogleService-Info.plist` for iOS
- Update Firebase configuration in `lib/firebase_options.dart`

4. Run the application
```bash
flutter run
```

## 📁 Project Structure

```
lib/
├── api/                  # API integration
├── background_functions/ # Background services
├── painters/            # Custom painters
├── main.dart            # Application entry point
├── firebase_options.dart # Firebase configuration
└── [feature_name].dart  # Feature-specific files
```

## 🛠️ Development

### Adding New Features

1. Create a new branch for your feature
```bash
git checkout -b feature/your-feature-name
```

2. Follow the existing code structure
- Place API calls in the `api` directory
- Use the existing state management pattern
- Follow the established naming conventions

3. Testing
- Add appropriate test cases
- Run tests using `flutter test`
- Ensure all existing tests pass

4. Submit a pull request
- Provide detailed description of changes
- Reference any related issues

### Code Style

- Follow Flutter's official style guide
- Use meaningful variable and function names
- Add comments for complex logic
- Keep functions small and focused

## 📦 Dependencies

Key packages used in this project:
- `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase integration
- `google_ml_kit` - ML capabilities
- `camera` - Camera functionality
- `flutter_local_notifications` - Push notifications
- `provider` - State management
- `table_calendar` - Calendar integration
- See `pubspec.yaml` for complete list

## 🔒 Security

- All Firebase security rules must be properly configured
- API keys and sensitive data should be stored securely
- Follow Flutter security best practices
- Regular security audits recommended

## 📱 Supported Platforms

- Android
- iOS
- Web
- Windows
- Linux
- macOS

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details

## 📞 Support

For support and queries:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## 🔄 Version History

- 1.0.0
  - Initial Release
  - Basic CRM functionality
  - Firebase integration

---

Built with ❤️ using Flutter
