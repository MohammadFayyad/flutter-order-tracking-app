import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:order_tracking/features/add_order/constants/map_constants.dart';
import 'package:order_tracking/features/add_order/cubit/place_picker_state.dart';
import 'package:order_tracking/features/add_order/services/geocoding_service.dart';
import 'package:order_tracking/features/add_order/services/location_service.dart';

class PlacePickerCubit extends Cubit<PlacePickerState> {
  PlacePickerCubit({
    required GeocodingService geocodingService,
    required LocationService locationService,
  }) : _geocodingService = geocodingService,
       _locationService = locationService,
       super(PlacePickerState.initial());

  final GeocodingService _geocodingService;
  final LocationService _locationService;
  MapboxMap? _mapBoxMap;

  Future<void> initializeMap(MapboxMap controller) async {
    _mapBoxMap = controller;

    await _mapBoxMap!.setCamera(
      CameraOptions(
        center: Point(
          coordinates: Position(
            MapConstants.defaultCairoLng,
            MapConstants.defaultCairoLat,
          ),
        ),
        zoom: MapConstants.defaultZoom,
      ),
    );

    await moveToCurrentLocation();
  }

  Future<void> moveToCurrentLocation() async {
    final result = await _locationService.getCurrentLocation();

    result.fold(
      (position) {
        _mapBoxMap?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(position.longitude, position.latitude),
            ),
            zoom: 16,
          ),
          MapAnimationOptions(),
        );
      },
      (error) {
        debugPrint("Location Error: $error");
      },
    );
  }

  void updateCoordinates(double latitude, double longitude) {
    if (isClosed) return;
    emit(
      state.copyWith(currentLatitude: latitude, currentLongitude: longitude),
    );
  }

  Future<void> updateAddress() async {
    if (isClosed) return;

    final result = await _geocodingService.reverseGeocode(
      longitude: state.currentLongitude,
      latitude: state.currentLatitude,
    );

    if (isClosed) return;

    result.fold(
      (address) {
        if (!isClosed) {
          emit(state.copyWith(selectedAddress: address));
        }
      },
      (error) {
        debugPrint("Geocoding Error: $error");
      },
    );
  }

  Future<List<Map<String, dynamic>>> searchPlaces(String query) async {
    final result = await _geocodingService.searchPlaces(query: query);
    return result.fold((places) => places, (error) {
      debugPrint("Search Error: $error");
      return [];
    });
  }

  void moveToPlace(Map<String, dynamic> place) {
    final coordsResult = _geocodingService.extractCoordinates(place);
    coordsResult.fold(
      (coords) {
        _mapBoxMap?.setCamera(
          CameraOptions(
            center: Point(
              coordinates: Position(coords['longitude']!, coords['latitude']!),
            ),
            zoom: 14,
          ),
        );
      },
      (error) {
        debugPrint("Coordinates Error: $error");
      },
    );
  }

  Map<String, dynamic> getLocationResult() {
    return {
      "lat": state.currentLatitude,
      "lng": state.currentLongitude,
      "address": state.selectedAddress,
    };
  }
}
