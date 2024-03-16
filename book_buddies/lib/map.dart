import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LibraryMapScreen extends StatelessWidget {
  const LibraryMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded library locations
    final List<LatLng> libraryLocations = [
      LatLng(38.123, -76.456),
      LatLng(38.234, -76.567),
      LatLng(38.345, -76.678),
      // Add more library locations as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Library Locations'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: libraryLocations.isNotEmpty
              ? libraryLocations.first
              : LatLng(0, 0),
          zoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          MarkerLayer(
            markers: [
              // Marker for each library location
              ...libraryLocations.map((location) => Marker(
                    width: 80.0,
                    height: 80.0,
                    point: location,
                    builder: (ctx) =>
                        const Icon(Icons.library_books, color: Colors.blue),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
