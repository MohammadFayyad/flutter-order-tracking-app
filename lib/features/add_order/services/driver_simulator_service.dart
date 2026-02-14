import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriverSimulatorService {
  final FirebaseFirestore firebaseFirestore;
  Timer? _simulationTimer;
  bool _isSimulating = false;

  DriverSimulatorService({required this.firebaseFirestore});

  void startSimulation({
    required String orderId,
    required double startLat,
    required double startLng,
    required double destLat,
    required double destLng,
    int updateIntervalSeconds = 3,
    double speedMetersPerSecond = 10.0, // ~36 km/h
  }) {
    if (_isSimulating) {
      debugPrint('Simulation already running');
      return;
    }

    _isSimulating = true;
    double currentLat = startLat;
    double currentLng = startLng;

    debugPrint('🚗 Starting driver simulation');
    debugPrint('From: ($startLat, $startLng)');
    debugPrint('To: ($destLat, $destLng)');

    _simulationTimer = Timer.periodic(
      Duration(seconds: updateIntervalSeconds),
      (timer) async {
        final distance = _calculateDistance(
          currentLat,
          currentLng,
          destLat,
          destLng,
        );

        debugPrint(
          '📍 Distance to destination: ${distance.toStringAsFixed(2)}m',
        );

        if (distance < 10) {
          debugPrint('✅ Driver arrived at destination!');
          stopSimulation();
          return;
        }

        final distanceToMove = speedMetersPerSecond * updateIntervalSeconds;

        final newPosition = _moveTowards(
          currentLat: currentLat,
          currentLng: currentLng,
          targetLat: destLat,
          targetLng: destLng,
          distanceMeters: distanceToMove,
        );

        currentLat = newPosition['lat']!;
        currentLng = newPosition['lng']!;
        try {
          await firebaseFirestore.collection('orders').doc(orderId).update({
            'orderLatitude': currentLat.toString(),
            'orderLongitude': currentLng.toString(),
          });
          debugPrint('🚗 Driver moved to: ($currentLat, $currentLng)');
        } catch (e) {
          debugPrint('❌ Error updating driver location: $e');
        }
      },
    );
  }

  void stopSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = null;
    _isSimulating = false;
    debugPrint('🛑 Driver simulation stopped');
  }

  double _calculateDistance(
    double lat1,
    double lng1,
    double lat2,
    double lng2,
  ) {
    const earthRadius = 6371000.0; // meters
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  Map<String, double> _moveTowards({
    required double currentLat,
    required double currentLng,
    required double targetLat,
    required double targetLng,
    required double distanceMeters,
  }) {
    final totalDistance = _calculateDistance(
      currentLat,
      currentLng,
      targetLat,
      targetLng,
    );

    if (distanceMeters >= totalDistance) {
      return {'lat': targetLat, 'lng': targetLng};
    }

    final fraction = distanceMeters / totalDistance;

    final newLat = currentLat + (targetLat - currentLat) * fraction;
    final newLng = currentLng + (targetLng - currentLng) * fraction;

    return {'lat': newLat, 'lng': newLng};
  }

  double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  bool get isSimulating => _isSimulating;
  void dispose() {
    stopSimulation();
  }
}
