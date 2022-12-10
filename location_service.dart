import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:maps_attempt_2/location_service.dart';
import 'package:async/async.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyAJN3Uzvr4qyxd99xTV5YP6ZbAncPzFQro';
  Future<String> getPlaceId(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$input&inputtype=textquery&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeId = json['candidates'][0]['place_id'] as String;
    //print(placeId);
    return placeId;
  }

  Future<Map<String, dynamic>> getPlace(String input) async {
    final placeId = await getPlaceId(input);
    final String url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['results'] as Map<String, dynamic>;
    print(results);
    return results;
  }

//
  Future<Map<String, dynamic>>getDirections(String origin, String destination) async {
    final String url =
        'https://maps.googleapis.com/maps/api/destinations/json?origin=$origin&destination=$destination&key=$key';
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results={
      'bounds_ne':json['routes'][0]['bounds']['northeast'],
      'bounds_sw':json['routes'][0]['bounds']['southwest'],
      'start_location':json['routes'][0]['legs'][0]['start_location'],
      'end_location':json['routes'][0]['legs'][0]['end_location'],
      'Polyline':json['routes'][0]['overview_polyline']['points'],
      'Polyline_decoded':PolylinePoints().decodePolyline(json['routes'][0]['overview_polyline']['points']
      )};
    
    print(results);
    
     return results;
  }
}
