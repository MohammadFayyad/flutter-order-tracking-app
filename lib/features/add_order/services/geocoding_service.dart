import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class GeocodingService {
  final Dio _dio;
  final String _accessToken;

  GeocodingService({required Dio dio})
    : _dio = dio,
      _accessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

  Future<ResultDart<String, String>> reverseGeocode({
    required double longitude,
    required double latitude,
  }) async {
    try {
      final response = await _dio.get(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$longitude,$latitude.json",
        queryParameters: {"access_token": _accessToken},
      );

      final features = response.data['features'];

      if (features == null || features.isEmpty) {
        return failureOf('No address found for this location');
      }

      final placeName = features[0]['place_name'] as String?;

      if (placeName == null) {
        return failureOf('Invalid address data');
      }

      return successOf(placeName);
    } on DioException catch (e) {
      return failureOf('Network error: ${e.message}');
    } catch (e) {
      return failureOf('Error getting address: $e');
    }
  }

  Future<ResultDart<List<Map<String, dynamic>>, String>> searchPlaces({
    required String query,
    int limit = 5,
  }) async {
    try {
      if (query.isEmpty) {
        return successOf([]);
      }

      final response = await _dio.get(
        "https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json",
        queryParameters: {"access_token": _accessToken, "limit": limit},
      );

      final features = response.data['features'] as List?;

      if (features == null) {
        return failureOf('Invalid response from server');
      }

      final places = features
          .map(
            (feature) => {
              'place_name': feature['place_name'] as String,
              'center': feature['center'] as List,
            },
          )
          .toList();

      return successOf(places);
    } on DioException catch (e) {
      return failureOf('Network error: ${e.message}');
    } catch (e) {
      return failureOf('Error searching places: $e');
    }
  }

  ResultDart<Map<String, double>, String> extractCoordinates(
    Map<String, dynamic> place,
  ) {
    try {
      final center = place['center'] as List?;

      if (center == null || center.length < 2) {
        return failureOf('Invalid coordinates in place data');
      }

      return successOf({
        'longitude': (center[0] as num).toDouble(),
        'latitude': (center[1] as num).toDouble(),
      });
    } catch (e) {
      return failureOf('Error extracting coordinates: $e');
    }
  }
}
