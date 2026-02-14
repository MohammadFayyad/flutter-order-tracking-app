import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  const OrderCard({super.key, required this.order});
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = order.orderDate != null
        ? DateFormat('yyyy-MM-dd').format(DateTime.parse(order.orderDate!))
        : 'N/A';
    return Card(
      color: Colors.white,
      elevation: 4,
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: _getStatusColor(order.orderStatus), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "Order ID: ${order.orderId ?? '-'}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24.sp,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order.orderStatus).withAlpha(50),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderStatus ?? 'Unknown',
                    style: TextStyle(
                      color: _getStatusColor(order.orderStatus),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Order Name: ${order.orderName ?? '-'}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
            ),
            const SizedBox(height: 6),
            Text("Arrival Date: $formattedDate"),
            const SizedBox(height: 6),
            Text("Order Location: ${order.orderAddress ?? 'No Address'}"),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: PrimaryButtonWidget(
                    height: 30,
                    buttonText: "Track Order",
                    onPress: () {
                      context.push(AppRoutes.orderTrackMapScreen, extra: order);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push(
                        AppRoutes.driverTrackingScreen,
                        extra: order,
                      );
                    },
                    icon: const Icon(Icons.gps_fixed, size: 16),
                    label: const Text('Driver Mode'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
