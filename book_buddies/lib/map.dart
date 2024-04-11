import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:latlong2/latlong.dart';

class LibraryMapScreen extends StatefulWidget {
  const LibraryMapScreen({super.key});

  @override
  _LibraryMapScreenState createState() => _LibraryMapScreenState();
}

class _LibraryMapScreenState extends State<LibraryMapScreen> {
  LatLng? userLocation;
  MapController mapController = MapController();
  List<PlacesSearchResult>? libraryLocations;
  List<LatLng>? friendLocations;
  final _places =
      GoogleMapsPlaces(apiKey: 'AIzaSyDqtBQsYDmTHXK-vKYXqRN1l89ua8pfmpU');

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _fetchUserLocation();
    if (userLocation != null) {
      await _fetchLibraryLocations();
      friendLocations = [
        LatLng(userLocation!.latitude + 0.20, userLocation!.longitude + 0.064),
        LatLng(userLocation!.latitude - 0.12, userLocation!.longitude + 0.03),
      ];
    }
  }

  Future<void> _fetchLibraryLocations() async {
    try {
      final result = await _places.searchNearbyWithRadius(
          Location(lat: userLocation!.latitude, lng: userLocation!.longitude),
          5000,
          keyword: 'library');
      if (result.status == "OK") {
        setState(() {
          libraryLocations = result.results;
        });
      } else {
        throw Exception(result.errorMessage);
      }
    } catch (e) {
      print('Error fetching library locations: $e');
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
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
        title: const Text('Libraries and Friends Near Me'),
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
                interactiveFlags:
                    InteractiveFlag.pinchZoom | InteractiveFlag.doubleTapZoom,
                maxZoom: 20,
                minZoom: 3,
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
                            point: LatLng(location.geometry!.location.lat,
                                location.geometry!.location.lng),
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
