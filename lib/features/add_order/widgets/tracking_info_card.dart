import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget to display tracking information (distance and status)
class TrackingInfoCard extends StatelessWidget {
  final double distanceInMeters;
  final String orderStatus;

  const TrackingInfoCard({
    super.key,
    required this.distanceInMeters,
    required this.orderStatus,
  });

  /// Format distance for display
  String _formatDistance() {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    } else {
      final km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(2)} km';
    }
  }

  /// Get status color
  Color _getStatusColor() {
    switch (orderStatus) {
      case 'Pending':
        return Colors.orange;
      case 'In Progress':
        return Colors.blue;
      case 'Nearby':
        return Colors.amber;
      case 'Arrived':
        return Colors.green;
      case 'Completed':
        return Colors.green.shade700;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  /// Get status icon
  IconData _getStatusIcon() {
    switch (orderStatus) {
      case 'Pending':
        return Icons.pending;
      case 'In Progress':
        return Icons.local_shipping;
      case 'Nearby':
        return Icons.near_me;
      case 'Arrived':
        return Icons.check_circle;
      case 'Completed':
        return Icons.done_all;
      case 'Cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _getStatusColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              _getStatusIcon(),
              color: _getStatusColor(),
              size: 32.sp,
            ),
          ),
          SizedBox(width: 16.w),
          // Status and Distance Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderStatus,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(),
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16.sp,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Distance: ${_formatDistance()}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

