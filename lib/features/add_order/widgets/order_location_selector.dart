import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_tracking/core/routing/app_routes.dart';
import 'package:order_tracking/core/styling/app_colors.dart';
import 'package:order_tracking/core/styling/app_styles.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';
import 'package:order_tracking/core/widgets/spacing_widgets.dart';

/// Widget for selecting order delivery location
/// Handles location selection and displays selected address
class OrderLocationSelector extends StatefulWidget {
  const OrderLocationSelector({
    super.key,
    required this.onLocationSelected,
  });

  final Function(double lat, double lng, String address) onLocationSelected;

  @override
  State<OrderLocationSelector> createState() => _OrderLocationSelectorState();
}

class _OrderLocationSelectorState extends State<OrderLocationSelector> {
  String _selectedAddress = '';

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
          onPress: _selectLocation,
        ),
        const HeightSpace(12),
        if (_selectedAddress.isNotEmpty) _buildAddressDisplay(),
      ],
    );
  }

  /// Navigate to place picker and handle result
  Future<void> _selectLocation() async {
    final result = await context.push<Map<String, dynamic>>(
      AppRoutes.placePickerScreen,
    );
    
    if (result != null) {
      final lat = result['lat'] as double?;
      final lng = result['lng'] as double?;
      final address = result['address'] as String? ?? '';
      
      if (lat != null && lng != null) {
        setState(() {
          _selectedAddress = address;
        });
        widget.onLocationSelected(lat, lng, address);
      }
    }
  }

  /// Display selected address in a styled container
  Widget _buildAddressDisplay() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            color: AppColors.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedAddress,
              style: AppStyles.grey12MediumStyle,
            ),
          ),
        ],
      ),
    );
  }
}

