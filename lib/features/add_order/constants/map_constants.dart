class MapConstants {
  MapConstants._();

  // Icon URLs
  static const String orderDestinationIconUrl =
      'https://cdn-icons-png.flaticon.com/128/684/684908.png';
  static const String driverIconUrl =
      'https://cdn-icons-png.flaticon.com/128/3774/3774278.png';

  // Map Configuration
  static const double defaultZoom = 8.0;
  static const double defaultIconSize = 0.5;
  static const double routeLineWidth = 6.0;
  static const int cameraAnimationDuration = 2000; // milliseconds

  static const double defaultCairoLat = 30.0444;
  static const double defaultCairoLng = 31.2357;

  static const double nearbyThreshold = 500.0;
  static const double arrivedThreshold = 50.0;

  // Order Status Values
  static const String statusPending = 'Pending';
  static const String statusInProgress = 'In Progress';
  static const String statusNearby = 'Nearby';
  static const String statusArrived = 'Arrived';
  static const String statusCompleted = 'Completed';
  static const String statusCancelled = 'Cancelled';

  // Firestore Collections
  static const String ordersCollection = 'orders';

  // Error Messages
  static const String noRouteFoundError = 'No route found';
  static const String invalidCoordinatesError = 'Invalid coordinates';
  static const String networkError = 'Network error occurred';
}
