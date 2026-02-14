import 'package:equatable/equatable.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

abstract class OrderTrackingState extends Equatable {
  const OrderTrackingState();

  @override
  List<Object?> get props => [];
}

final class OrderTrackingInitial extends OrderTrackingState {}

final class OrderTrackingLoading extends OrderTrackingState {}

final class OrderTrackingMapInitialized extends OrderTrackingState {
  final double orderLatitude;
  final double orderLongitude;

  const OrderTrackingMapInitialized({
    required this.orderLatitude,
    required this.orderLongitude,
  });

  @override
  List<Object?> get props => [orderLatitude, orderLongitude];
}

final class OrderTrackingDriverUpdated extends OrderTrackingState {
  final double driverLatitude;
  final double driverLongitude;
  final List<Position> route;
  final double distanceInMeters;
  final String orderStatus;

  const OrderTrackingDriverUpdated({
    required this.driverLatitude,
    required this.driverLongitude,
    required this.route,
    required this.distanceInMeters,
    required this.orderStatus,
  });

  @override
  List<Object?> get props => [
    driverLatitude,
    driverLongitude,
    route,
    distanceInMeters,
    orderStatus,
  ];
}

final class OrderTrackingRouteUpdated extends OrderTrackingState {
  final List<Position> route;

  const OrderTrackingRouteUpdated({required this.route});

  @override
  List<Object?> get props => [route];
}

final class OrderTrackingError extends OrderTrackingState {
  final String message;

  const OrderTrackingError({required this.message});

  @override
  List<Object?> get props => [message];
}

final class OrderTrackingDisposed extends OrderTrackingState {}
