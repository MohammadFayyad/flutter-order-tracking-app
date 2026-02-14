import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class OrderTrackingRepo {
  final FirebaseFirestore firebaseFirestore;
  final Dio dio;

  OrderTrackingRepo({required this.firebaseFirestore, required this.dio});

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamOrderUpdates(
    String orderId,
  ) {
    return firebaseFirestore.collection('orders').doc(orderId).snapshots();
  }

  Future<ResultDart<List<Position>, String>> fetchRoute({
    required double fromLng,
    required double fromLat,
    required double toLng,
    required double toLat,
  }) async {
    try {
      final response = await dio.get(
        "https://api.mapbox.com/directions/v5/mapbox/driving/"
        "$fromLng,$fromLat;$toLng,$toLat",
        queryParameters: {
          "access_token": dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? "",
          "geometries": "geojson",
        },
      );

      final data = response.data;
      if (data == null) {
        return failureOf('Response data is null');
      }

      final routes = data['routes'];
      if (routes == null || routes is! List || routes.isEmpty) {
        return failureOf('No routes found in response');
      }

      final geometry = routes[0]['geometry'];
      if (geometry == null) {
        return failureOf('No geometry found in route');
      }

      final coords = geometry['coordinates'];
      if (coords == null || coords is! List) {
        return failureOf('No coordinates found in geometry');
      }

      final positions = coords
          .map<Position>((c) => Position(c[0].toDouble(), c[1].toDouble()))
          .toList();

      return successOf(positions);
    } on DioException catch (e) {
      return failureOf(e.message ?? 'Network error occurred');
    } catch (e) {
      return failureOf('Error fetching route: $e');
    }
  }

  ResultDart<Map<String, double>, String> parseDriverCoordinates(
    Map<String, dynamic> data,
  ) {
    try {
      final driverLat = double.tryParse(
        data['orderLatitude']?.toString() ?? '',
      );
      final driverLng = double.tryParse(
        data['orderLongitude']?.toString() ?? '',
      );

      if (driverLat == null || driverLng == null) {
        return failureOf('Invalid coordinates in data');
      }

      return successOf({'latitude': driverLat, 'longitude': driverLng});
    } catch (e) {
      return failureOf('Error parsing coordinates: $e');
    }
  }
}
