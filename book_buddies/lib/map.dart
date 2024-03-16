import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LibraryMapScreen extends StatefulWidget {
  const LibraryMapScreen({Key? key}) : super(key: key);

  @override
  _LibraryMapScreenState createState() => _LibraryMapScreenState();
}

class _LibraryMapScreenState extends State<LibraryMapScreen> {
  LatLng? userLocation;
  MapController mapController = MapController();
  List<LatLng>? libraryLocations;
  List<LatLng>? friendLocations;

  @override
  void initState() {
    super.initState();
    _fetchUserLocation();
    // hardcoded library and friend locations for now
    if (userLocation != null) {
      libraryLocations = [
        LatLng(userLocation!.latitude + 0.05, userLocation!.longitude + 0.05),
        LatLng(userLocation!.latitude - 0.07, userLocation!.longitude + 0.02),
        LatLng(userLocation!.latitude - 0.068, userLocation!.longitude - 0.017),
      ];
      friendLocations = [
        LatLng(userLocation!.latitude + 0.20, userLocation!.longitude + 0.064),
        LatLng(userLocation!.latitude - 0.12, userLocation!.longitude + 0.03),
      ];
    }
  }

  Future<void> _fetchUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          userLocation = LatLng(position.latitude, position.longitude);
        });
      } else {
        // Handle denied permissions
        print('Location permission denied');
      }
    } catch (e) {
      print('Error fetching user location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Locations'),
      ),
      body: userLocation == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : FlutterMap(
              mapController: mapController,
              options: MapOptions(
                center: userLocation!,
                zoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: userLocation!,
                      builder: (ctx) => const Icon(Icons.person_pin_circle,
                          color: Colors.blue),
                    ),
                    if (friendLocations != null)
                      ...friendLocations!.map((location) => Marker(
                            width: 80.0,
                            height: 80.0,
                            point: location,
                            builder: (ctx) =>
                                const Icon(Icons.person, color: Colors.blue),
                          )),
                    if (libraryLocations != null)
                      ...libraryLocations!.map((location) => Marker(
                            width: 80.0,
                            height: 80.0,
                            point: location,
                            builder: (ctx) => const Icon(Icons.library_books,
                                color: Colors.blue),
                          )),
                  ],
                ),
              ],
            ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class LibraryMapScreen extends StatelessWidget {
//   const LibraryMapScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final List<LatLng> libraryLocations = [
//       LatLng(38.123, -76.456),
//       LatLng(38.234, -76.567),
//       LatLng(38.345, -76.678),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Library Locations'),
//       ),
//       body: FlutterMap(
//         options: MapOptions(
//           center: libraryLocations.isNotEmpty
//               ? libraryLocations.first
//               : LatLng(0, 0),
//           zoom: 10,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             userAgentPackageName: 'com.example.app',
//           ),
//           MarkerLayer(
//             markers: [
//               // Marker for each library location
//               ...libraryLocations.map((location) => Marker(
//                     width: 80.0,
//                     height: 80.0,
//                     point: location,
//                     builder: (ctx) =>
//                         const Icon(Icons.library_books, color: Colors.blue),
//                   )),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
