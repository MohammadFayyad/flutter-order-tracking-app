import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/core/di/dependency_injection.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';
import 'package:order_tracking/features/add_order/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';

/// Submit button for creating a new order
/// Validates form and location before submission
class OrderSubmitButton extends StatelessWidget {
  const OrderSubmitButton({
    super.key,
    required this.formKey,
    required this.orderIdController,
    required this.orderNameController,
    required this.arrivalDateController,
    required this.orderLat,
    required this.orderLng,
    required this.orderAddress,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController orderIdController;
  final TextEditingController orderNameController;
  final TextEditingController arrivalDateController;
  final double? orderLat;
  final double? orderLng;
  final String orderAddress;

  @override
  Widget build(BuildContext context) {
    return PrimaryButtonWidget(
      buttonText: "Create Order",
      onPress: () => _handleSubmit(context),
    );
  }

  /// Validate and submit order
  void _handleSubmit(BuildContext context) {
    // Validate form fields
    if (!formKey.currentState!.validate()) {
      return;
    }

    // Validate location selection
    if (orderLat == null || orderLng == null) {
      showAnimatedSnackDialog(
        context,
        type: AnimatedSnackBarType.error,
        message: "Please select order location",
      );
      return;
    }

    // Parse arrival date
    final DateTime orderArrivalDate;
    try {
      orderArrivalDate = DateTime.parse(arrivalDateController.text);
    } catch (e) {
      showAnimatedSnackDialog(
        context,
        type: AnimatedSnackBarType.error,
        message: "Invalid arrival date",
      );
      return;
    }

    // Create and submit order
    final order = OrderModel(
      orderId: orderIdController.text,
      orderName: orderNameController.text,
      // Driver location - initially set to "0" until driver accepts order
      orderLatitude: "0",
      orderLongitude: "0",
      orderStatus: 'Pending',
      orderDate: orderArrivalDate.toString(),
      orderUserId: sl<FirebaseAuth>().currentUser!.uid,
      // Order destination - the delivery address
      userModel: UserModel(
        userLatitude: orderLat.toString(),
        userLongitude: orderLng.toString(),
      ),
      orderAddress: orderAddress,
    );

    context.read<OrderCubit>().addOrder(order);
  }
}

