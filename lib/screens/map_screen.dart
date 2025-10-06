import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tarea_map/constants/config.dart';
import 'package:tarea_map/widgets/bottom_nav_bar.dart';
import 'package:tarea_map/widgets/build_coordinate_card.dart';
import 'package:tarea_map/widgets/circular_fab.dart';
import 'package:tarea_map/widgets/location_details_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController
  mapController; // Map controller is used to control the map view

  // Center of the map, using environment variables for default coordinates
  late final LatLng _center = AppConfig.defaultLocation;
  bool _showDetails = false;
  MapType _currentMapType = MapType.normal;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _changeMapType(MapType mapType) {
    setState(() {
      _currentMapType = mapType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
            markers: {
              Marker(
                markerId: const MarkerId('marker_test'),
                position: _center,
                onTap: () {
                  setState(() {
                    _showDetails = true;
                  });
                },
              ),
            },
            mapType: _currentMapType,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
          ),

          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: CoordinateCard(
              latitude: _center.latitude,
              longitude: _center.longitude,
            ),
          ),

          Positioned(
            top: 155,
            right: 16,
            child: Column(
              children: [
                CircularFAB(icon: Icons.search, onPressed: () {}),
                const SizedBox(height: 12),
                CircularFAB(
                  icon: Icons.navigation_outlined,
                  onPressed: () {
                    // TODO: Implement navigation to target location
                    mapController.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(target: _center, zoom: 11.0),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                CircularFAB(
                  icon: Icons.layers_outlined,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Seleccionar tipo de mapa',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ListTile(
                              title: const Text('Normal'),
                              leading: const Icon(Icons.map),
                              onTap: () {
                                mapController.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(target: _center, zoom: 11.0),
                                  ),
                                );
                                _changeMapType(MapType.normal);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Satélite'),
                              leading: const Icon(Icons.satellite),
                              onTap: () {
                                _changeMapType(MapType.satellite);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('íbrido'),
                              leading: const Icon(Icons.layers),
                              onTap: () {
                                _changeMapType(MapType.hybrid);

                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              title: const Text('Terreno'),
                              leading: const Icon(Icons.terrain),
                              selected: _currentMapType == MapType.terrain,
                              onTap: () {
                                _changeMapType(MapType.terrain);
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),

                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 200,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black87,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.location_searching, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _showDetails = true;
                  });
                },
              ),
            ),
          ),

          if(!_showDetails)  BottomNavBar(),

          if (_showDetails)
            LocationDetailsSheet(
              onClose: () {
                setState(() {
                  _showDetails = false;
                });
              },
              latitude: _center.latitude.toStringAsFixed(6),
              longitude: _center.longitude.toStringAsFixed(6),
            ),
        ],
      ),
    );
  }
}
