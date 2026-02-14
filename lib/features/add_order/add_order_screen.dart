import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/loading_widget.dart';
import 'package:order_tracking/core/widgets/order_details_form.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';
import 'package:order_tracking/features/add_order/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order/cubit/order_state.dart';
import 'package:order_tracking/features/add_order/widgets/add_order_header.dart';
import 'package:order_tracking/features/add_order/widgets/order_location_selector.dart';
import 'package:order_tracking/features/add_order/widgets/order_submit_button.dart';

class AddOrderScreen extends StatefulWidget {
  const AddOrderScreen({super.key});

  @override
  State<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends State<AddOrderScreen> {
  late final TextEditingController _arrivalDateController;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _orderIdController;
  late final TextEditingController _orderNameController;

  double? _orderLat;
  double? _orderLng;
  String _orderAddress = '';

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    _arrivalDateController = TextEditingController();
    _orderIdController = TextEditingController();
    _orderNameController = TextEditingController();
  }

  @override
  void dispose() {
    _arrivalDateController.dispose();
    _orderIdController.dispose();
    _orderNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: BlocConsumer<OrderCubit, OrderState>(
          listener: _handleStateChanges,
          builder: (context, state) {
            if (state is OrderLoading) {
              return const Center(child: LoadingWidget());
            }
            return _buildBody();
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      title: Text("Add Order", style: TextStyle(color: AppColors.primaryColor)),
    );
  }

  void _handleStateChanges(BuildContext context, OrderState state) {
    if (state is OrderSuccess) {
      showAnimatedSnackDialog(
        context,
        type: AnimatedSnackBarType.success,
        message: state.message,
      );
      context.push(AppRoutes.myOrdersScreen);
    }
    if (state is OrderError) {
      showAnimatedSnackDialog(
        context,
        type: AnimatedSnackBarType.error,
        message: state.message,
      );
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 22.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AddOrderHeader(),
              OrderDetailsForm(
                arrivalDateController: _arrivalDateController,
                orderIdController: _orderIdController,
                orderNameController: _orderNameController,
              ),
              const HeightSpace(20),
              OrderLocationSelector(
                onLocationSelected: _handleLocationSelected,
              ),
              const HeightSpace(55),
              OrderSubmitButton(
                formKey: _formKey,
                orderIdController: _orderIdController,
                orderNameController: _orderNameController,
                arrivalDateController: _arrivalDateController,
                orderLat: _orderLat,
                orderLng: _orderLng,
                orderAddress: _orderAddress,
              ),
              const HeightSpace(8),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLocationSelected(double lat, double lng, String address) {
    setState(() {
      _orderLat = lat;
      _orderLng = lng;
      _orderAddress = address;
    });
  }
}
