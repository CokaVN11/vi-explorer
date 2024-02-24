import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../settings/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapView extends StatefulWidget {
  const MapView({super.key});

  static const routeName = '/map';

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(10.8231, 106.6291);
  final Map<String, Marker> _markers = {};


  void _onMapCreated(GoogleMapController controller) {
    _markers.clear();
    mapController = controller;
  }

  Future<List<String>> _onAutoCompleteSearch(String keyword) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/queryautocomplete/json?input=$keyword&key=$GOOGLE_MAP_API&language=vi&location=10.8231,106.6291&radius=10000';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }

      final List<String> suggestions = [];
      for (final prediction in data['predictions']) {
        suggestions.add(prediction['description']);
      }
      return suggestions;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return [];
  }

  Future<LatLng> _onGeocodeSearch(String keyword) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$keyword&key=$GOOGLE_MAP_API';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }

      final LatLng location = LatLng(
          data['results'][0]['geometry']['location']['lat'],
          data['results'][0]['geometry']['location']['lng']);
      return location;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return _center;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          markers: _markers.values.toSet(),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
        Container(
            color: Colors.transparent,
            margin: const EdgeInsets.all(20.0),
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  hintText: 'Find something...',
                  controller: controller,
                  padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 16.0)),
                  onTap: () {
                    controller.openView();
                  },
                  onChanged: (_) {
                    _onAutoCompleteSearch(controller.text);
                  },
                  leading: const Icon(Icons.search),
                );
              },
              suggestionsBuilder: (context, controller) async {
                final String keyword = controller.text;
                final List<String> suggestions =
                    await _onAutoCompleteSearch(keyword);

                return List<ListTile>.generate(
                    (suggestions).length,
                    (index) => ListTile(
                          title: Text(suggestions[index]),
                          onTap: () async {
                            controller.text = suggestions[index];
                            final newLatLng = await _onGeocodeSearch(
                              suggestions[index]);
                            _markers.clear();
                            _markers['newLocation'] = Marker(
                              markerId: const MarkerId('newLocation'),
                              position: newLatLng,
                              infoWindow: const InfoWindow(
                                title: 'New Location',
                                snippet: 'This is the new location',
                              ),
                            );
                            setState(() {});
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: newLatLng,
                                    zoom: 17.0)));

                            controller.closeView(suggestions[index]);
                          },
                        ));
              },
            )),
      ],
    ));
  }
}
