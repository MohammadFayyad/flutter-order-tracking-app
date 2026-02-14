import 'package:equatable/equatable.dart';
import 'package:order_tracking/features/add_order/constants/map_constants.dart';

class PlacePickerState extends Equatable {
  const PlacePickerState({
    required this.currentLatitude,
    required this.currentLongitude,
    required this.selectedAddress,
  });

  final double currentLatitude;
  final double currentLongitude;
  final String selectedAddress;

  factory PlacePickerState.initial() {
    return const PlacePickerState(
      currentLatitude: MapConstants.defaultCairoLat,
      currentLongitude: MapConstants.defaultCairoLng,
      selectedAddress: "Move map to select location",
    );
  }
  PlacePickerState copyWith({
    double? currentLatitude,
    double? currentLongitude,
    String? selectedAddress,
  }) {
    return PlacePickerState(
      currentLatitude: currentLatitude ?? this.currentLatitude,
      currentLongitude: currentLongitude ?? this.currentLongitude,
      selectedAddress: selectedAddress ?? this.selectedAddress,
    );
  }

  @override
  List<Object?> get props => [
    currentLatitude,
    currentLongitude,
    selectedAddress,
  ];
}
