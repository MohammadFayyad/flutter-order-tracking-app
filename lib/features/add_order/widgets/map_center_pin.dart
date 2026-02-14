import 'package:flutter/material.dart';

/// Center pin widget for map location selection
/// Displays a fixed pin in the center of the map
class MapCenterPin extends StatelessWidget {
  const MapCenterPin({
    super.key,
    this.size = 50,
    this.color = Colors.red,
    this.icon = Icons.location_pin,
  });

  final double size;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        icon,
        size: size,
        color: color,
      ),
    );
  }
}

