import 'dart:convert';
import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'locations.dart' as locations;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// A service that stores and retrieves map data from Google Maps API.

class MapService {
  // Search a k location by keyword from Google Maps API.
  // Return the first 5 results as a list of Map<String, dynamic>
  // with title, address, lat, and lng.
  Future<Map<String, dynamic>> search(String keyword) async {
    final url = Uri.parse('https://maps.googleapis.com/maps/api/place/textsearch/json?query=$keyword&language=vi&key=AIzaSyAs0P-uY0grNE0Eg4r-yuy4C931jKgXve8');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final result = [];
          for (var i = 0; i < min(5, data['results'].length); i++) {
            result.add({
              'title': data['results'][i]['name'],
              'address': data['results'][i]['formatted_address'],
              'lat': data['results'][i]['geometry']['location']['lat'],
              'lng': data['results'][i]['geometry']['location']['lng'],
            });
          }
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
    }

    return {};
  }


  LatLng center() {
    return const LatLng(10.8231, 106.6297);
  }

  Future<Map<String, Marker>> markers() async {
    final googleOffices = await locations.getGoogleOffices();
    final Map<String, Marker> markers = {};
    for (final office in googleOffices.offices) {
      final marker = Marker(
        markerId: MarkerId(office.name),
        position: LatLng(office.lat, office.lng),
        infoWindow: InfoWindow(
          title: office.name,
          snippet: office.address,
        ),
      );
      markers[office.name] = marker;
    }
    return markers;
  }

  updateMap(LatLng newCenter, Map<String, Marker> newMarkers) {
    // Update the map data on the server
  }
}