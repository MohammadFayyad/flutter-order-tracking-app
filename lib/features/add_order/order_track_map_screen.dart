import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:order_tracking/core/di/dependency_injection.dart';
import 'package:order_tracking/features/add_order/cubit/order_tracking_cubit.dart';
import 'package:order_tracking/features/add_order/cubit/order_tracking_state.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';

class OrderTrackMapScreen extends StatelessWidget {
  const OrderTrackMapScreen({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<OrderTrackingCubit>(),
      child: _OrderTrackMapScreenContent(orderModel: orderModel),
    );
  }
}

class _OrderTrackMapScreenContent extends StatelessWidget {
  const _OrderTrackMapScreenContent({required this.orderModel});
  final OrderModel orderModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Track Order"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: BlocConsumer<OrderTrackingCubit, OrderTrackingState>(
        listener: (context, state) {
          if (state is OrderTrackingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return MapWidget(
            onMapCreated: (controller) async {
              final cubit = context.read<OrderTrackingCubit>();
              await cubit.initializeMap(
                mapBoxMap: controller,
                orderModel: orderModel,
              );
              if (orderModel.orderId != null) {
                cubit.startDriverTracking(orderModel.orderId!);
              }
            },
          );
        },
      ),
    );
  }
}
