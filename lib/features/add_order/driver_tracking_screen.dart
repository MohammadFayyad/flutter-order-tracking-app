import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:order_tracking/core/di/dependency_injection.dart';
import 'package:order_tracking/features/add_order/models/add_order_model.dart';
import 'package:order_tracking/features/add_order/services/driver_location_tracker.dart';

class DriverTrackingScreen extends StatefulWidget {
  const DriverTrackingScreen({super.key, required this.orderModel});
  final OrderModel orderModel;

  @override
  State<DriverTrackingScreen> createState() => _DriverTrackingScreenState();
}

class _DriverTrackingScreenState extends State<DriverTrackingScreen> {
  final DriverLocationTracker _locationTracker = sl<DriverLocationTracker>();
  Position? _currentPosition;
  bool _isTracking = false;

  @override
  void dispose() {
    _locationTracker.stopTracking();
    super.dispose();
  }

  Future<void> _startTracking() async {
    if (widget.orderModel.orderId == null) {
      _showMessage('Error: Order ID is missing', isError: true);
      return;
    }

    await _locationTracker.startTracking(orderId: widget.orderModel.orderId!);

    setState(() {
      _isTracking = true;
    });

    _showMessage('📍 Location tracking started!');
    _updateCurrentLocation();
  }

  void _stopTracking() {
    _locationTracker.stopTracking();
    setState(() {
      _isTracking = false;
    });
    _showMessage('🛑 Location tracking stopped', isError: true);
  }

  Future<void> _updateCurrentLocation() async {
    final position = await _locationTracker.getCurrentLocation();
    if (position != null) {
      setState(() {
        _currentPosition = position;
      });
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.orange : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Location Tracking'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildInfoRow(
                      'Order ID',
                      widget.orderModel.orderId ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Order Name',
                      widget.orderModel.orderName ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Status',
                      widget.orderModel.orderStatus ?? 'N/A',
                    ),
                    _buildInfoRow(
                      'Destination',
                      widget.orderModel.orderAddress ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Card(
              elevation: 4,
              color: _isTracking ? Colors.green.shade50 : Colors.grey.shade100,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _isTracking ? Icons.gps_fixed : Icons.gps_off,
                          color: _isTracking ? Colors.green : Colors.grey,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          _isTracking ? 'Tracking Active' : 'Tracking Inactive',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: _isTracking ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    if (_currentPosition != null) ...[
                      SizedBox(height: 12.h),
                      _buildInfoRow(
                        'Latitude',
                        _currentPosition!.latitude.toStringAsFixed(6),
                      ),
                      _buildInfoRow(
                        'Longitude',
                        _currentPosition!.longitude.toStringAsFixed(6),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),

            // Control Buttons
            if (!_isTracking)
              ElevatedButton.icon(
                onPressed: _startTracking,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Location Tracking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  textStyle: TextStyle(fontSize: 18.sp),
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: _stopTracking,
                icon: const Icon(Icons.stop),
                label: const Text('Stop Location Tracking'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  textStyle: TextStyle(fontSize: 18.sp),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100.w,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 14.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
