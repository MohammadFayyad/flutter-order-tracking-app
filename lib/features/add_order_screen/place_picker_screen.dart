import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker_google/place_picker_google.dart';

class PlacePickerScreen extends StatefulWidget {
  const PlacePickerScreen({super.key});

  @override
  PlacePickerScreenState createState() => PlacePickerScreenState();
}

class PlacePickerScreenState extends State<PlacePickerScreen> {
  @override
  Widget build(BuildContext context) {
    final googleMapsApiKey = Platform.isAndroid
        ? dotenv.env['GOOGLE_MAPS_API_KEY_ANDROID']
        : dotenv.env['GOOGLE_MAPS_API_KEY_IOS'];
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: PlacePicker(
        apiKey: googleMapsApiKey ?? '',
        onPlacePicked: (LocationResult result) {
          debugPrint("Place picked: \\${result.formattedAddress}");
          context.pop(result.latLng);
        },
        initialLocation: const LatLng(29.378586, 47.990341),
        searchInputConfig: const SearchInputConfig(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          autofocus: false,
          textDirection: TextDirection.ltr,
        ),
        searchInputDecorationConfig: const SearchInputDecorationConfig(
          hintText: "Search for a building, street or ...",
        ),
      ),
    );
  }
}
