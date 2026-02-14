# 📦 Order Tracking App

A comprehensive Flutter application for real-time order tracking with GPS location tracking, interactive maps, and automatic status updates.

## ✨ Features

### 🗺️ Real-Time GPS Tracking

- **Driver Location Tracking**: Real-time GPS tracking from driver's device using Geolocator
- **Live Map Updates**: Customer can see driver's location update in real-time on Mapbox maps
- **Automatic Status Updates**: Order status changes automatically based on distance (In Progress → Nearby → Arrived)
- **Distance Calculation**: Real-time distance calculation between driver and destination using Haversine formula

### 👤 Dual User Interfaces

- **Customer View**: Track orders on interactive map with driver location and route visualization
- **Driver View**: Dedicated screen to start/stop location sharing with order details

### 📍 Location Features

- **Place Picker**: Interactive map-based location selection with search functionality
- **Geocoding**: Forward and reverse geocoding using Mapbox API
- **Address Search**: Search for locations by name or address
- **Current Location**: Automatic detection of user's current location

### 🔥 Firebase Integration

- **Firestore**: Real-time database for orders and location updates
- **Firebase Auth**: User authentication and authorization
- **Real-time Sync**: Instant synchronization across all devices

### 🏗️ Clean Architecture

- **BLoC Pattern**: State management using Cubit (flutter_bloc)
- **Repository Pattern**: Separation of data layer from business logic
- **Service Layer**: Dedicated services for location, geocoding, and maps
- **Dependency Injection**: Using get_it for dependency management

## 📱 Screenshots

<!-- Add your screenshots here -->

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Mapbox account (for maps and geocoding)
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/order_tracking.git
   cd order_tracking
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Set up Firebase**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add Android/iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/google-services.json`
     - iOS: `ios/Runner/GoogleService-Info.plist`
   - Run FlutterFire CLI to configure:
     ```bash
     flutterfire configure
     ```

4. **Set up Mapbox**
   - Create a Mapbox account at [Mapbox](https://www.mapbox.com/)
   - Get your Mapbox Access Token from the [Mapbox Account](https://account.mapbox.com/) page
   - Create a `.env` file in the root directory (see `.env.example`)

5. **Configure environment variables**
   - Copy `.env.example` to `.env`
   - Add your Mapbox access token:
     ```
     MAPBOX_ACCESS_TOKEN=your_mapbox_access_token_here
     ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔧 Configuration

### Environment Variables

Create a `.env` file in the root directory with the following variables:

```env
MAPBOX_ACCESS_TOKEN=your_mapbox_access_token_here
```

### Firebase Setup

1. Enable **Firestore Database** in your Firebase project
2. Enable **Authentication** (Email/Password)
3. Set up Firestore security rules (see `firebase.json`)

### Firestore Data Structure

```
orders/
  ├── {orderId}/
      ├── orderId: string
      ├── orderName: string
      ├── orderStatus: string
      ├── orderDate: string
      ├── orderAddress: string
      ├── orderLatitude: string (driver's current location)
      ├── orderLongitude: string (driver's current location)
      └── userModel/
          ├── userId: string
          ├── userName: string
          ├── userLatitude: string (order destination)
          └── userLongitude: string (order destination)
```

## 📖 Usage

### For Customers

1. **Create an Order**
   - Open the app and navigate to "Add Order"
   - Fill in order details (name, arrival date)
   - Select delivery location using the map picker
   - Submit the order

2. **Track an Order**
   - Go to "My Orders"
   - Click "Track Order" button on any order
   - View real-time driver location on the map
   - See distance and status updates

### For Drivers

1. **Start Location Tracking**
   - Go to "My Orders"
   - Click "Driver Mode" button on the order you're delivering
   - Review order details
   - Click "Start Location Tracking"
   - Grant location permissions when prompted

2. **Drive to Destination**
   - Your location updates automatically every 10 meters
   - Customer can see your location in real-time
   - Order status updates automatically based on distance

3. **Stop Tracking**
   - Click "Stop Location Tracking" when delivery is complete

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                          # Core functionality
│   ├── di/                        # Dependency injection
│   ├── routing/                   # Navigation and routing
│   ├── styling/                   # App theme and colors
│   ├── utils/                     # Utility functions
│   └── widgets/                   # Reusable widgets
│
├── features/                      # Feature modules
│   ├── add_order/                 # Order creation and tracking
│   │   ├── cubit/                 # State management (BLoC)
│   │   ├── models/                # Data models
│   │   ├── repo/                  # Repository layer
│   │   ├── services/              # Business logic services
│   │   ├── widgets/               # Feature-specific widgets
│   │   ├── constants/             # Feature constants
│   │   ├── add_order_screen.dart
│   │   ├── driver_tracking_screen.dart
│   │   ├── order_track_map_screen.dart
│   │   └── place_picker_screen.dart
│   │
│   ├── auth/                      # Authentication
│   │   ├── cubit/
│   │   ├── models/
│   │   ├── repo/
│   │   ├── login_screen.dart
│   │   └── register_screen.dart
│   │
│   └── home_screen/               # Home screen
│
├── firebase_options.dart          # Firebase configuration
└── main.dart                      # App entry point
```

### Key Architectural Patterns

- **BLoC Pattern**: State management using Cubit for predictable state changes
- **Repository Pattern**: Abstraction layer between data sources and business logic
- **Service Layer**: Dedicated services for specific functionalities (GPS, Geocoding, Maps)
- **Dependency Injection**: Centralized dependency management using get_it

## 📦 Dependencies

### Core Dependencies

- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **go_router**: Navigation and routing
- **equatable**: Value equality for state comparison

### Firebase

- **firebase_core**: Firebase core functionality
- **firebase_auth**: User authentication
- **cloud_firestore**: Real-time database

### Maps & Location

- **mapbox_maps_flutter**: Interactive maps
- **geolocator**: GPS location tracking
- **geocoding**: Address geocoding

### UI

- **flutter_screenutil**: Responsive UI
- **intl**: Internationalization and date formatting
- **animated_snack_bar**: Animated notifications

### Utilities

- **dio**: HTTP client for API calls
- **result_dart**: Result type for error handling
- **flutter_dotenv**: Environment variable management
- **flutter_secure_storage**: Secure local storage

## 🔐 Permissions

### Android

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
```

### iOS

Add to `ios/Runner/Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location for order tracking.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location for real-time driver tracking.</string>
```

## 🧪 Testing

Run tests:

```bash
flutter test
```

Run with coverage:

```bash
flutter test --coverage
```

## 🐛 Troubleshooting

### Common Issues

1. **Mapbox not showing**
   - Verify your Mapbox access token in `.env`
   - Check internet connection
   - Ensure Mapbox token has proper permissions

2. **Location not updating**
   - Grant location permissions in device settings
   - Check GPS is enabled on device
   - Verify Firestore rules allow writes

3. **Firebase connection issues**
   - Verify `google-services.json` is in correct location
   - Run `flutterfire configure` again
   - Check Firebase project settings

4. **Build errors**
   - Run `flutter clean`
   - Run `flutter pub get`
   - Delete `build` folder and rebuild

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👥 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📧 Contact

For questions or support, please open an issue on GitHub.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI framework
- [Firebase](https://firebase.google.com/) - Backend services
- [Mapbox](https://www.mapbox.com/) - Maps and geocoding
- [BLoC Library](https://bloclibrary.dev/) - State management

---

**Made with ❤️ using Flutter**
