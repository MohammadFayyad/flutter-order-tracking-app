import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:order_tracking/features/add_order/cubit/place_picker_cubit.dart';
import 'package:order_tracking/features/add_order/cubit/place_picker_state.dart';
import 'package:order_tracking/features/add_order/services/geocoding_service.dart';
import 'package:order_tracking/features/add_order/services/location_service.dart';
import 'package:order_tracking/features/add_order/widgets/location_confirmation_sheet.dart';
import 'package:order_tracking/features/add_order/widgets/map_center_pin.dart';
import 'package:order_tracking/features/add_order/widgets/place_search_bar.dart';

class PlacePickerScreen extends StatelessWidget {
  const PlacePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlacePickerCubit(
        geocodingService: GeocodingService(dio: Dio()),
        locationService: LocationService(),
      ),
      child: const _PlacePickerView(),
    );
  }
}

class _PlacePickerView extends StatelessWidget {
  const _PlacePickerView();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlacePickerCubit>();

    return Scaffold(
      body: Stack(
        children: [
          _buildMap(cubit),
          const MapCenterPin(),
          _buildSearchBar(cubit),
          _buildConfirmationSheet(context, cubit),
        ],
      ),
    );
  }

  Widget _buildMap(PlacePickerCubit cubit) {
    return MapWidget(
      onMapCreated: cubit.initializeMap,
      onCameraChangeListener: (event) {
        final center = event.cameraState.center;
        cubit.updateCoordinates(
          center.coordinates.lat.toDouble(),
          center.coordinates.lng.toDouble(),
        );
      },
      onMapIdleListener: (_) => cubit.updateAddress(),
    );
  }

  Widget _buildSearchBar(PlacePickerCubit cubit) {
    return Positioned(
      top: 50,
      left: 16,
      right: 16,
      child: PlaceSearchBar(
        onSearch: cubit.searchPlaces,
        onPlaceSelected: cubit.moveToPlace,
      ),
    );
  }

  Widget _buildConfirmationSheet(BuildContext context, PlacePickerCubit cubit) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: BlocBuilder<PlacePickerCubit, PlacePickerState>(
        builder: (context, state) {
          return LocationConfirmationSheet(
            address: state.selectedAddress,
            onConfirm: () => context.pop(cubit.getLocationResult()),
            onCancel: () => context.pop(),
          );
        },
      ),
    );
  }
}
