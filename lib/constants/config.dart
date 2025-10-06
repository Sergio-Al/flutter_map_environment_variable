import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppConfig {
  // Default coordinates
  static LatLng get defaultLocation => LatLng(
    double.tryParse(dotenv.env['DEFAULT_LAT'] ?? '') ?? -16.495833,
    double.tryParse(dotenv.env['DEFAULT_LNG'] ?? '') ?? -68.133333,
  );

  // Google Maps API Key
  static String get googleMapsApiKey => 
    dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
}
