import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Search bar widget for place picker
/// Provides autocomplete search functionality for locations
class PlaceSearchBar extends StatelessWidget {
  const PlaceSearchBar({
    super.key,
    required this.onSearch,
    required this.onPlaceSelected,
  });

  final Future<List<Map<String, dynamic>>> Function(String query) onSearch;
  final void Function(Map<String, dynamic> place) onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<Map<String, dynamic>>(
      suggestionsCallback: onSearch,
      itemBuilder: _buildSuggestionItem,
      onSelected: onPlaceSelected,
      builder: _buildSearchField,
    );
  }

  /// Build individual suggestion item
  Widget _buildSuggestionItem(
    BuildContext context,
    Map<String, dynamic> suggestion,
  ) {
    return ListTile(
      leading: const Icon(Icons.location_on, color: Colors.red),
      title: Text(
        suggestion['place_name'] ?? '',
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  /// Build search text field
  Widget _buildSearchField(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
  ) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: "Search location...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
    );
  }
}

