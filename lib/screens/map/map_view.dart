import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../settings/global.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BottomSheet extends StatelessWidget {
  final String cityName;
  final String generalInfo;

  const BottomSheet(
      {super.key, required this.cityName, required this.generalInfo});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 350.0,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        child: Column(
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 5.0, color: Colors.white),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 30.0),
                child: SizedBox(
                  width: 100.0,
                  height: 10.0,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFD9D9D9),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                  ),
                ),
              ),
            ),
            Text(
              cityName,
              style:
                  const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 18.0,
                left: 18.0,
                right: 18.0,
                bottom: 10.0,
              ),
              child: Text(
                maxLines: 6,
                generalInfo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/location');
              },
              child: Column(
                children: <Widget>[
                  const Icon(Icons.keyboard_arrow_up, size: 30.0),
                  Text(
                    'XEM THÊM VỀ $cityName'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 14.0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
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

  FirebaseFirestore db = FirebaseFirestore.instance;

  final _marker_colors = <String, double>{
    'visited': BitmapDescriptor.hueAzure,
    'new': BitmapDescriptor.hueGreen
  };
  final Map<String, Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _initMarkers();
  }

  Future<void> _initMarkers() async {
    final markers = await _createCityMarkers();
    setState(() {
      _markers.addAll(markers);
    });
  }

  Future<Map<String, Marker>> _createCityMarkers() async {
    final regions = {};
    final regionsSnapshot = await db.collection('regions').get();
    regionsSnapshot.docs.forEach((element) {
      final data = element.data();
      final name = data['name'];
      final info = data['info'];
      final latLng = LatLng(data['coor'].latitude, data['coor'].longitude);
      regions[data['id']] = {
        'name': name,
        'info': info,
        'latLng': latLng,
        'status': 'new'
      };
    });

    final userSnapshot = await db.collection('users').get();
    final user = userSnapshot.docs.first.data();
    final visited = List<String>.from(user['visited']);

    visited.forEach((element) {
      final regionId = element.substring(element.length - 3);
      if (regions.containsKey(regionId)) {
        regions[regionId]['status'] = 'visited';
      }
    });
    if (kDebugMode) {
      print(regions);
    }

    final markers = <String, Marker>{};
    regions.forEach((key, value) {
      markers[key] = _createMarker(
          value['name'], value['info'], value['latLng'], value['status']);
    });
    return markers;
  }

  Marker _createMarker(
      String city, String info, LatLng position, String status) {
    return Marker(
      onTap:
          status != 'search' ? () => _showModalBottomSheet(city, info) : null,
      markerId: MarkerId(city),
      position: position,
      icon: status == 'search'
          ? BitmapDescriptor.defaultMarker
          : BitmapDescriptor.defaultMarkerWithHue(_marker_colors[status]!),
    );
  }

  void _showModalBottomSheet(String city, String info) {
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(cityName: city, generalInfo: info),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
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
            margin: const EdgeInsets.only(
              top: 40.0,
              left: 20.0,
              right: 20.0,
            ),
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

                return suggestions.map((suggestion) {
                  return ListTile(
                    title: Text(suggestion),
                    onTap: () => _onSuggestionTap(controller, suggestion),
                  );
                }).toList();
              },
            )),
      ],
    ));
  }

  void _onSuggestionTap(SearchController controller, String suggestion) async {
    controller.text = suggestion;
    final newLatLng = await _onGeocodeSearch(suggestion);
    _markers['newLocation'] = _createMarker('newLocation', '',
        LatLng(newLatLng['lat'], newLatLng['lng']), 'search');
    setState(() {});
    mapController.animateCamera(
        CameraUpdate.newLatLng(LatLng(newLatLng['lat'], newLatLng['lng'])));
    controller.closeView(suggestion);
  }
}
