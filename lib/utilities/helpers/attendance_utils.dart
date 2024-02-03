import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//* The point-in-polygon algorithm
bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
  bool isInside = false;

  int numVertices = polygon.length;
  int j = numVertices - 1;

  for (int i = 0; i < numVertices; i++) {
    LatLng vertexI = polygon[i];
    LatLng vertexJ = polygon[j];

    //* Check if point is on edge of polygon
    if ((vertexI.longitude == point.longitude &&
            vertexI.latitude == point.latitude) ||
        (vertexJ.longitude == point.longitude &&
            vertexJ.latitude == point.latitude)) {
      return true;
    }

    //* Check if point is between vertices
    if ((vertexI.latitude < point.latitude &&
            vertexJ.latitude >= point.latitude) ||
        (vertexJ.latitude < point.latitude &&
            vertexI.latitude >= point.latitude)) {
      if (vertexI.longitude +
              (point.latitude - vertexI.latitude) /
                  (vertexJ.latitude - vertexI.latitude) *
                  (vertexJ.longitude - vertexI.longitude) <
          point.longitude) {
        isInside = !isInside;
      }
    }

    j = i;
  }

  return isInside;
}

Future<Position> getCurrentLocation() async =>
    await Geolocator.getCurrentPosition();