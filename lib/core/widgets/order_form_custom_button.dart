import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/di/dependency_injection.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/add_order/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';

class OrderFormCustomButton extends StatefulWidget {
  const OrderFormCustomButton({
    super.key,
    required this.arrivalDateController,
    required this.orderIdController,
    required this.orderNameController,
    required this.formKey,
  });

  final TextEditingController arrivalDateController;
  final TextEditingController orderIdController;
  final TextEditingController orderNameController;
  final GlobalKey<FormState> formKey;
  @override
  State<OrderFormCustomButton> createState() => OrderFormCustomButtonState();
}

class OrderFormCustomButtonState extends State<OrderFormCustomButton> {
  late final TextEditingController arrivalDateController;
  late final GlobalKey<FormState> formKey;
  DateTime? orderArrivalDate;
  late final TextEditingController orderIdController;
  double? orderLat;
  double? orderLng;
  String orderLocationAddress = '';
  late final TextEditingController orderNameController;

  @override
  void initState() {
    formKey = widget.formKey;
    arrivalDateController = widget.arrivalDateController;
    orderIdController = widget.orderIdController;
    orderNameController = widget.orderNameController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButtonWidget(
          buttonText: "Select Location",
          icon: const Icon(
            Icons.location_on_rounded,
            color: Colors.white,
            size: 20,
          ),
          onPress: () async {
            final result = await context.push<Map<String, dynamic>>(
              AppRoutes.placePickerScreen,
            );
            if (result != null) {
              orderLat = result['lat'];
              orderLng = result['lng'];
              orderLocationAddress = result['address'];
              setState(() {});
            }
          },
        ),
        const HeightSpace(12),
        if (orderLocationAddress.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.greyColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              orderLocationAddress,
              style: AppStyles.grey12MediumStyle,
            ),
          ),
        const HeightSpace(55),
        PrimaryButtonWidget(
          buttonText: "Create Order",
          onPress: () {
            orderArrivalDate = DateTime.parse(arrivalDateController.text);
            if (formKey.currentState!.validate()) {
              if (orderLat == null || orderLng == null) {
                showAnimatedSnackDialog(
                  context,
                  type: AnimatedSnackBarType.error,
                  message: "Please select order location",
                );
                return;
              }
              context.read<OrderCubit>().addOrder(
                OrderModel(
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
                  orderAddress: orderLocationAddress,
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
