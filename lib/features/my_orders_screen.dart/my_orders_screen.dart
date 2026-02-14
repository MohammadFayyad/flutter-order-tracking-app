import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/utils/animated_snack_dialog.dart';
import 'package:order_tracking/core/widgets/order_card.dart';
import 'package:order_tracking/features/add_order/cubit/order_cubit.dart';
import 'package:order_tracking/features/add_order/cubit/order_state.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});
  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "My Orders",
          style: TextStyle(color: AppColors.primaryColor),
        ),
      ),
      body: BlocConsumer<OrderCubit, OrderState>(
        listener: (context, state) {
          if (state is OrderLoadedError) {
            showAnimatedSnackDialog(
              context,
              type: AnimatedSnackBarType.error,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is OrderLoadedSuccess) {
            final orders = state.orderList;
            if (orders.isEmpty) {
              return const Center(
                child: Text('No orders yet.', style: TextStyle(fontSize: 16)),
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order);
              },
            );
          }
          return const Center(child: Text('No orders found.'));
        },
      ),
    );
  }
}
