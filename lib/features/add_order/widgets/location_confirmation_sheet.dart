import 'package:flutter/material.dart';
import 'package:order_tracking/core/widgets/primary_button_widget.dart';

/// Bottom sheet widget for confirming selected location
/// Displays address and provides confirm/cancel actions
class LocationConfirmationSheet extends StatelessWidget {
  const LocationConfirmationSheet({
    super.key,
    required this.address,
    required this.onConfirm,
    required this.onCancel,
  });

  final String address;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 12),
          _buildAddressDisplay(),
          const SizedBox(height: 16),
          _buildConfirmButton(),
          const SizedBox(height: 10),
          _buildCancelButton(),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Build drag handle indicator
  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  /// Build address display
  Widget _buildAddressDisplay() {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            address,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  /// Build confirm button
  Widget _buildConfirmButton() {
    return PrimaryButtonWidget(
      width: double.infinity,
      height: 48,
      onPress: onConfirm,
      buttonText: "Confirm Location",
    );
  }

  /// Build cancel button
  Widget _buildCancelButton() {
    return OutlinedButton(
      onPressed: onCancel,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 48),
        side: const BorderSide(color: Colors.grey),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text(
        "Cancel",
        style: TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

