import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:order_tracking/features/add_order/constants/map_constants.dart';
import 'package:order_tracking/features/add_order/cubit/order_tracking_state.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';
import 'package:order_tracking/features/add_order/repo/order_repo.dart';
import 'package:order_tracking/features/add_order/repo/order_tracking_repo.dart';
import 'package:order_tracking/features/add_order/services/driver_simulator_service.dart';
import 'package:order_tracking/features/add_order/services/map_service.dart';

class OrderTrackingCubit extends Cubit<OrderTrackingState> {
  final OrderTrackingRepo orderTrackingRepo;
  final OrderRepo orderRepo;
  final MapService mapService;
  final DriverSimulatorService driverSimulator;

  StreamSubscription? _driverSubscription;
  MapboxMap? _mapBoxMap;
  double? _orderLat;
  double? _orderLng;
  String? _orderId;
  String? _currentStatus;

  OrderTrackingCubit({
    required this.orderTrackingRepo,
    required this.orderRepo,
    required this.mapService,
    required this.driverSimulator,
  }) : super(OrderTrackingInitial());

  Future<void> initializeMap({
    required MapboxMap mapBoxMap,
    required OrderModel orderModel,
  }) async {
    try {
      emit(OrderTrackingLoading());

      _mapBoxMap = mapBoxMap;
      _orderId = orderModel.orderId;
      _currentStatus = orderModel.orderStatus;

      _orderLat =
          double.tryParse(orderModel.userModel?.userLatitude ?? '0') ?? 0.0;
      _orderLng =
          double.tryParse(orderModel.userModel?.userLongitude ?? '0') ?? 0.0;

      await mapService.setInitialCamera(
        mapBoxMap: mapBoxMap,
        latitude: _orderLat!,
        longitude: _orderLng!,
        zoom: MapConstants.defaultZoom,
      );

      final markerResult = await mapService.addOrderMarker(
        mapBoxMap: mapBoxMap,
        latitude: _orderLat!,
        longitude: _orderLng!,
        iconUrl: MapConstants.orderDestinationIconUrl,
        iconSize: MapConstants.defaultIconSize,
      );

      markerResult.fold(
        (_) {
          if (isClosed) return;
          emit(
            OrderTrackingMapInitialized(
              orderLatitude: _orderLat!,
              orderLongitude: _orderLng!,
            ),
          );
        },
        (error) {
          if (isClosed) return;
          emit(OrderTrackingError(message: error));
        },
      );
    } catch (e) {
      if (isClosed) return;
      emit(OrderTrackingError(message: 'Error initializing map: $e'));
    }
  }

  void startDriverTracking(String orderId) {
    try {
      _driverSubscription = orderTrackingRepo
          .streamOrderUpdates(orderId)
          .listen((snapshot) async {
            if (!snapshot.exists || _mapBoxMap == null) return;

            final data = snapshot.data();
            if (data == null) return;

            // Parse driver coordinates
            final coordsResult = orderTrackingRepo.parseDriverCoordinates(data);

            await coordsResult.fold(
              (coords) async {
                final driverLat = coords['latitude']!;
                final driverLng = coords['longitude']!;

                // Update driver marker
                await mapService.updateDriverMarker(
                  mapBoxMap: _mapBoxMap!,
                  latitude: driverLat,
                  longitude: driverLng,
                  iconUrl: MapConstants.driverIconUrl,
                  iconSize: MapConstants.defaultIconSize,
                );

                // Calculate distance and update status
                if (_orderLat != null && _orderLng != null) {
                  final distance = _calculateDistance(
                    driverLat: driverLat,
                    driverLng: driverLng,
                    orderLat: _orderLat!,
                    orderLng: _orderLng!,
                  );

                  // Determine new status based on distance
                  final newStatus = _determineStatusByDistance(distance);

                  // Update status if needed
                  await _updateOrderStatusIfNeeded(newStatus);

                  // Fetch and draw route
                  final routeResult = await orderTrackingRepo.fetchRoute(
                    fromLng: driverLng,
                    fromLat: driverLat,
                    toLng: _orderLng!,
                    toLat: _orderLat!,
                  );

                  await routeResult.fold(
                    (route) async {
                      // Draw route on map
                      await mapService.drawRoute(
                        mapBoxMap: _mapBoxMap!,
                        route: route,
                        lineWidth: MapConstants.routeLineWidth,
                      );

                      // Animate camera to driver location
                      mapService.animateCamera(
                        mapBoxMap: _mapBoxMap!,
                        latitude: driverLat,
                        longitude: driverLng,
                        zoom: MapConstants.defaultZoom,
                        duration: MapConstants.cameraAnimationDuration,
                      );

                      if (isClosed) return;
                      emit(
                        OrderTrackingDriverUpdated(
                          driverLatitude: driverLat,
                          driverLongitude: driverLng,
                          route: route,
                          distanceInMeters: distance,
                          orderStatus: newStatus,
                        ),
                      );
                    },
                    (error) {
                      debugPrint('Route fetch error: $error');
                      // Still update driver position even if route fails
                      if (isClosed) return;
                      emit(
                        OrderTrackingDriverUpdated(
                          driverLatitude: driverLat,
                          driverLongitude: driverLng,
                          route: [],
                          distanceInMeters: distance,
                          orderStatus: newStatus,
                        ),
                      );
                    },
                  );
                }
              },
              (error) {
                debugPrint('Coordinate parsing error: $error');
              },
            );
          });
    } catch (e) {
      if (isClosed) return;
      emit(OrderTrackingError(message: 'Error starting tracking: $e'));
    }
  }

  double _calculateDistance({
    required double driverLat,
    required double driverLng,
    required double orderLat,
    required double orderLng,
  }) {
    return Geolocator.distanceBetween(driverLat, driverLng, orderLat, orderLng);
  }

  String _determineStatusByDistance(double distanceInMeters) {
    if (distanceInMeters <= MapConstants.arrivedThreshold) {
      return MapConstants.statusArrived;
    } else if (distanceInMeters <= MapConstants.nearbyThreshold) {
      return MapConstants.statusNearby;
    } else {
      return MapConstants.statusInProgress;
    }
  }

  /// Update order status if it has changed
  Future<void> _updateOrderStatusIfNeeded(String newStatus) async {
    if (_orderId == null || _currentStatus == newStatus) return;

    final result = await orderRepo.updateOrderStatus(
      orderId: _orderId!,
      newStatus: newStatus,
    );

    result.fold(
      (_) {
        _currentStatus = newStatus;
        debugPrint('Order status updated to: $newStatus');
      },
      (error) {
        debugPrint('Failed to update order status: $error');
      },
    );
  }

  /// Start simulating driver movement
  /// Simulates driver moving from a starting point to the order destination
  void startDriverSimulation({
    required String orderId,
    required double startLat,
    required double startLng,
  }) {
    if (_orderLat == null || _orderLng == null) {
      debugPrint('Cannot start simulation: Order destination not set');
      return;
    }

    debugPrint('🚗 Starting driver simulation for order: $orderId');
    driverSimulator.startSimulation(
      orderId: orderId,
      startLat: startLat,
      startLng: startLng,
      destLat: _orderLat!,
      destLng: _orderLng!,
      updateIntervalSeconds: 3, // Update every 3 seconds
      speedMetersPerSecond: 10.0, // ~36 km/h
    );
  }

  /// Stop driver simulation
  void stopDriverSimulation() {
    driverSimulator.stopSimulation();
  }

  /// Stop tracking and cleanup
  @override
  Future<void> close() {
    _driverSubscription?.cancel();
    driverSimulator.dispose();
    mapService.dispose();
    return super.close();
  }
}
