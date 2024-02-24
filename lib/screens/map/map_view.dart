import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../settings/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BottomSheet extends StatelessWidget{
  const BottomSheet({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 350.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0)),
        ),
        child: Column(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 5.0, color: Colors.white),
              ),
              child: Padding(
                padding:
                const EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: SizedBox(
                  width: 100.0,
                  height: 10.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.rectangle,
                      borderRadius:
                      BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
            ),
            const Text(
              'Ho Chi Minh',
              style: TextStyle(
                  fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Padding(
              padding: EdgeInsets.all(18.0),
              child: Text(
                // padding
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const TextButton(
              onPressed: null,
              child: Column(
                children: <Widget>[
                  Icon(Icons.keyboard_arrow_up, size: 30.0),
                  Text(
                    'XEM THÊM VỀ TP.HCM',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

}

class MapView extends StatefulWidget {
  const MapView({super.key});

  static const routeName = '/map';

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(14.0583, 108.2772);
  late final Map<String, double> _marker_colors = <String, double>{
    'visited': BitmapDescriptor.hueAzure,
    'new': BitmapDescriptor.hueGreen
  };

  late final Map<String, Marker> _city = {
    'Da Lat': Marker(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {return const BottomSheet();});
      },
      markerId: const MarkerId('Da Lat'),
      position: const LatLng(11.9404, 108.4580),
      icon: BitmapDescriptor.defaultMarkerWithHue(_marker_colors['new']!),
    ),
    'Da Nang': Marker(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {return const BottomSheet();});
      },
      markerId: const MarkerId('Da Nang'),
      position: const LatLng(16.0544, 108.2022),
      icon: BitmapDescriptor.defaultMarkerWithHue(_marker_colors['new']!),
    ),
    'Ha Noi': Marker(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (context) {return const BottomSheet();});
      },
      markerId: const MarkerId('Ha Noi'),
      position: const LatLng(21.0285, 105.8542),
      icon: BitmapDescriptor.defaultMarkerWithHue(_marker_colors['new']!),
    ),
    'Ho Chi Minh': Marker(
        onTap: () {
          showModalBottomSheet(
              context: context,
              builder: (context) {return const BottomSheet();});
        },
        markerId: const MarkerId('Ho Chi Minh'),
        position: const LatLng(10.8231, 106.6291),
        infoWindow: const InfoWindow(
          title: 'Ho Chi Minh',
          snippet: 'This is Ho Chi Minh city',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(_marker_colors['visited']!))
  };

  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _markers.clear();
    _markers.addAll(_city);
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

  Future<Map<String, dynamic>> _onGeocodeSearch(String keyword) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$keyword&key=$GOOGLE_MAP_API';
    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);
      if (kDebugMode) {
        print(data);
      }

      final Map<String, dynamic> location = {
        'address': data['results'][0]['address_components'][2]['long_name'],
        'lat': data['results'][0]['geometry']['location']['lat'],
        'lng': data['results'][0]['geometry']['location']['lng']
      };
      return location;
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }

    return {'address': '', 'lat': _center.latitude, 'lng': _center.longitude};
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
            zoom: 7.0,
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
                            final newLatLng =
                                await _onGeocodeSearch(suggestions[index]);
                            _markers.clear();
                            _markers['newLocation'] = Marker(
                              markerId: const MarkerId('newLocation'),
                              position:
                                  LatLng(newLatLng['lat'], newLatLng['lng']),
                              infoWindow: const InfoWindow(
                                title: 'New Location',
                                snippet: 'This is the new location',
                              ),
                            );
                            setState(() {});
                            mapController.animateCamera(
                                CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(
                                        newLatLng['lat'], newLatLng['lng']),
                                    zoom: 9.0)));

                            controller.closeView(suggestions[index]);
                          },
                        ));
              },
            )),
      ],
    ));
  }
}
