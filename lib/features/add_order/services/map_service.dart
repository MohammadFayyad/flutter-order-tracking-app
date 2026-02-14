import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class MapService {
  final Dio dio;

  MapService({required this.dio});

  PointAnnotationManager? _orderMarkerManager;
  PointAnnotationManager? _driverMarkerManager;
  PolylineAnnotationManager? _routeManager;
  PointAnnotation? _driverMarker;

  Future<ResultDart<Uint8List, String>> loadImageFromUrl(String url) async {
    try {
      final response = await dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.data == null) {
        return failureOf('No image data received');
      }

      return successOf(Uint8List.fromList(response.data!));
    } on DioException catch (e) {
      return failureOf(e.message ?? 'Failed to load image');
    } catch (e) {
      return failureOf('Error loading image: $e');
    }
  }

  Future<ResultDart<void, String>> addOrderMarker({
    required MapboxMap mapBoxMap,
    required double latitude,
    required double longitude,
    required String iconUrl,
    double iconSize = 0.5,
  }) async {
    try {
      _orderMarkerManager = await mapBoxMap.annotations
          .createPointAnnotationManager();
      final iconResult = await loadImageFromUrl(iconUrl);
      await iconResult.fold(
        (iconBytes) async {
          await _orderMarkerManager!.create(
            PointAnnotationOptions(
              geometry: Point(coordinates: Position(longitude, latitude)),
              image: iconBytes,
              iconSize: iconSize,
            ),
          );
        },
        (_) async {
          await _orderMarkerManager!.create(
            PointAnnotationOptions(
              geometry: Point(coordinates: Position(longitude, latitude)),
              iconColor: Colors.red.toARGB32(),
              iconSize: iconSize,
            ),
          );
        },
      );

      return successOf(unit);
    } catch (e) {
      return failureOf('Error adding order marker: $e');
    }
  }

  Future<ResultDart<void, String>> updateDriverMarker({
    required MapboxMap mapBoxMap,
    required double latitude,
    required double longitude,
    required String iconUrl,
    double iconSize = 0.5,
  }) async {
    try {
      if (_driverMarker == null) {
        _driverMarkerManager = await mapBoxMap.annotations
            .createPointAnnotationManager();

        final iconResult = await loadImageFromUrl(iconUrl);

        await iconResult.fold(
          (iconBytes) async {
            _driverMarker = await _driverMarkerManager!.create(
              PointAnnotationOptions(
                geometry: Point(coordinates: Position(longitude, latitude)),
                image: iconBytes,
                iconSize: iconSize,
              ),
            );
          },
          (_) async {
            _driverMarker = await _driverMarkerManager!.create(
              PointAnnotationOptions(
                geometry: Point(coordinates: Position(longitude, latitude)),
                iconColor: Colors.blue.toARGB32(),
                iconSize: iconSize,
              ),
            );
          },
        );
      } else {
        _driverMarker!.geometry = Point(
          coordinates: Position(longitude, latitude),
        );
        if (_driverMarkerManager != null) {
          await _driverMarkerManager!.update(_driverMarker!);
        }
      }

      return successOf(unit);
    } catch (e) {
      return failureOf('Error updating driver marker: $e');
    }
  }

  Future<ResultDart<void, String>> drawRoute({
    required MapboxMap mapBoxMap,
    required List<Position> route,
    Color? lineColor,
    double lineWidth = 6.0,
  }) async {
    try {
      if (route.isEmpty) {
        return successOf(unit);
      }

      _routeManager ??= await mapBoxMap.annotations
          .createPolylineAnnotationManager();

      await _routeManager!.deleteAll();
      await _routeManager!.create(
        PolylineAnnotationOptions(
          geometry: LineString(coordinates: route),
          lineColor: (lineColor ?? Colors.blue).toARGB32(),
          lineWidth: lineWidth,
        ),
      );

      return successOf(unit);
    } catch (e) {
      return failureOf('Error drawing route: $e');
    }
  }

  void animateCamera({
    required MapboxMap mapBoxMap,
    required double latitude,
    required double longitude,
    double zoom = 10.0,
    int duration = 2000,
  }) {
    mapBoxMap.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(longitude, latitude)),
        zoom: zoom,
      ),
      MapAnimationOptions(duration: duration),
    );
  }

  Future<void> setInitialCamera({
    required MapboxMap mapBoxMap,
    required double latitude,
    required double longitude,
    double zoom = 10.0,
  }) async {
    await mapBoxMap.setCamera(
      CameraOptions(
        center: Point(coordinates: Position(longitude, latitude)),
        zoom: zoom,
      ),
    );
  }

  void dispose() {
    _orderMarkerManager = null;
    _driverMarkerManager = null;
    _routeManager = null;
    _driverMarker = null;
  }
}
