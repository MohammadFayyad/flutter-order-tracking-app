import 'dart:developer';

import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_assets.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/custom_text_field.dart';
import 'package:order_tracking/core/widgets/loading_widget.dart';
import 'package:order_tracking/core/widgets/primay_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/add_order_screen/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order_screen/cubit/order_state.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() =>
      _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late final TextEditingController arrivalDateController;
  final GlobalKey<FormState> formKey =
      GlobalKey<FormState>();
  DateTime? orderArrivalDate;
  late final TextEditingController orderIdController;
  LatLng? orderLocation;
  late final TextEditingController orderNameController;
  LatLng? userLocation;
  String orderLocationAddress = '';

  @override
  void dispose() {
    orderIdController.dispose();
    orderNameController.dispose();
    arrivalDateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    orderIdController = TextEditingController();
    orderNameController = TextEditingController();
    arrivalDateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('rebuild');
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: LoadingWidget());
            }
            if (state is OrderError) {
              showAnimatedSnackDialog(
                context,
                type: AnimatedSnackBarType.error,
                message: state.message,
              );
            }

            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const HeightSpace(28),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "Create Your New Order ",
                          style: AppStyles
                              .primaryHeadLinesStyle,
                        ),
                      ),
                      const HeightSpace(8),
                      SizedBox(
                        width: 335.w,
                        child: Text(
                          "Let’s create your new order.",
                          style:
                              AppStyles.grey12MediumStyle,
                        ),
                      ),
                      const HeightSpace(20),
                      Center(
                        child: Image.asset(
                          AppAssets.logo,
                          width: 190.w,
                          height: 190.w,
                        ),
                      ),
                      const HeightSpace(32),
                      Text(
                        "Order Id",
                        style: AppStyles.black16w500Style,
                      ),
                      const HeightSpace(8),
                      CustomTextField(
                        controller: orderIdController,
                        hintText: "Enter Your Order Id",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Order Id";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(8),
                      Text(
                        "Arrival Date",
                        style: AppStyles.black16w500Style,
                      ),
                      CustomTextField(
                        readOnly: true,
                        onFieldSubmitted: (value) {
                          showDatePicker(
                            routeSettings:
                                const RouteSettings(
                                  name: "DatePickerDialog",
                                ),
                            initialDatePickerMode:
                                DatePickerMode.day,
                            initialEntryMode:
                                DatePickerEntryMode
                                    .calendar,
                            confirmText: "Confirm",
                            cancelText: "Cancel",
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context)
                                    .copyWith(
                                      colorScheme:
                                          ColorScheme.light(
                                            primary: AppColors
                                                .primaryColor,
                                          ),
                                    ),
                                child: child!,
                              );
                            },
                            initialDate: DateTime.now(),
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          ).then(((value) {
                            if (value != null &&
                                value != orderArrivalDate) {
                              orderArrivalDate = value;
                              setState(() {
                                arrivalDateController.text =
                                    DateFormat(
                                      "yyyy-MM-dd",
                                    ).format(value);
                              });
                            }
                          }));
                        },
                        controller: arrivalDateController,
                        hintText: "Enter Arrival Date",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Arrival Date";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(8),
                      Text(
                        "Order Name",
                        style: AppStyles.black16w500Style,
                      ),
                      CustomTextField(
                        controller: orderNameController,
                        hintText: "Enter Your Order Name",
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter Your Order Name";
                          }
                          return null;
                        },
                      ),
                      const HeightSpace(16),
                      PrimaryButtonWidget(
                        buttonText: "Select Location",
                        icon: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPress: () async {
                          LatLng? latLng = await context
                              .push<LatLng>(
                                AppRoutes.placePickerScreen,
                              );
                          if (latLng != null) {
                            orderLocation = latLng;
                            List<Placemark> placemarks =
                                await placemarkFromCoordinates(
                                  orderLocation!.latitude,
                                  orderLocation!.longitude,
                                );
                            orderLocationAddress =
                                "${placemarks.first.country!} ${placemarks.first.administrativeArea!} ${placemarks.first.locality!} ${placemarks.first.street!} ${placemarks.first.name!}";

                            setState(() {});
                          }
                        },
                      ),
                      orderLocationAddress.isNotEmpty
                          ? Text(orderLocationAddress)
                          : SizedBox.shrink(),
                      const HeightSpace(55),
                      PrimaryButtonWidget(
                        buttonText: "Create Order",
                        onPress: () {
                          if (formKey.currentState!
                              .validate()) {}
                        },
                      ),
                      const HeightSpace(8),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
