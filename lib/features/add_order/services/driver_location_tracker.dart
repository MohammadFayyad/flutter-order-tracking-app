import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class DriverLocationTracker {
  final FirebaseFirestore firebaseFirestore;
  StreamSubscription<Position>? _locationSubscription;
  bool _isTracking = false;

  DriverLocationTracker({required this.firebaseFirestore});

  Future<void> startTracking({required String orderId}) async {
    if (_isTracking) {
      debugPrint('Location tracking already running');
      return;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('❌ Location services are disabled');
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint('❌ Location permission denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint('❌ Location permission denied forever');
      await Geolocator.openAppSettings();
      return;
    }

    _isTracking = true;
    debugPrint('📍 Starting real-time location tracking for order: $orderId');

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _locationSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) async {
            debugPrint('📍 Driver location updated:');
            debugPrint('   Latitude: ${position.latitude}');
            debugPrint('   Longitude: ${position.longitude}');
            debugPrint('   Accuracy: ${position.accuracy}m');
            debugPrint('   Speed: ${position.speed}m/s');

            try {
              await firebaseFirestore.collection('orders').doc(orderId).update({
                'orderLatitude': position.latitude.toString(),
                'orderLongitude': position.longitude.toString(),
              });
              debugPrint('✅ Firestore updated with driver location');
            } catch (e) {
              debugPrint('❌ Error updating Firestore: $e');
            }
          },
          onError: (error) {
            debugPrint('❌ Location tracking error: $error');
          },
        );
  }

  void stopTracking() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _isTracking = false;
    debugPrint('🛑 Location tracking stopped');
  }

  Future<Position?> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('❌ Location services are disabled');
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('❌ Location permission denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('❌ Location permission denied forever');
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      debugPrint(
        '📍 Current location: (${position.latitude}, ${position.longitude})',
      );
      return position;
    } catch (e) {
      debugPrint('❌ Error getting current location: $e');
      return null;
    }
  }

  Future<void> updateCurrentLocation(String orderId) async {
    final position = await getCurrentLocation();
    if (position != null) {
      try {
        await firebaseFirestore.collection('orders').doc(orderId).update({
          'orderLatitude': position.latitude.toString(),
          'orderLongitude': position.longitude.toString(),
        });
        debugPrint('✅ Firestore updated with current location');
      } catch (e) {
        debugPrint('❌ Error updating Firestore: $e');
      }
    }
  }

  bool get isTracking => _isTracking;

  void dispose() {
    stopTracking();
  }
}
