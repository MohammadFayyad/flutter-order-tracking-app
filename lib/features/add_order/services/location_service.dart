import 'package:geolocator/geolocator.dart';
import 'package:result_dart/functions.dart';
import 'package:result_dart/result_dart.dart';

class LocationService {
  Future<ResultDart<Position, String>> getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        return failureOf('Location services are disabled');
      }

      final permissionResult = await _checkAndRequestPermission();

      if (permissionResult.isError()) {
        return failureOf(permissionResult.exceptionOrNull()!);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      return successOf(position);
    } catch (e) {
      return failureOf('Error getting location: $e');
    }
  }

  Future<ResultDart<void, String>> _checkAndRequestPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        return failureOf(
          'Location permission denied permanently. Please enable in settings.',
        );
      }

      if (permission == LocationPermission.denied) {
        return failureOf('Location permission denied');
      }

      return successOf(unit);
    } catch (e) {
      return failureOf('Error checking permission: $e');
    }
  }

  Future<bool> isPermissionGranted() async {
    final permission = await Geolocator.checkPermission();
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<void> openSettings() async {
    await Geolocator.openAppSettings();
  }
}
