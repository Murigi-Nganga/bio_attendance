import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class AttendanceLocation {
  String name;
  List<LatLng>? polygonPoints;

  AttendanceLocation({
    required this.name,
    this.polygonPoints,
  });

  factory AttendanceLocation.fromJson(Map<String, dynamic> data) {
    return AttendanceLocation(
        name: data['name'],
        //? Convert the string to a list of LatLng objects
        polygonPoints: data['polygon_points'] == null
            ? null
            : (json.decode(data['polygon_points']) as List<dynamic>)
                .map((point) => LatLng(point[0], point[1]))
                .toList(),
      );
  }
      

  Map<String, dynamic> toJson() => {
        'name': name,
        'polygon_points': polygonPoints,
      };

  @override
  String toString() {
    return name;
  }
}