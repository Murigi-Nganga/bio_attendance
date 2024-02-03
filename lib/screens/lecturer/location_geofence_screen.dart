import 'dart:convert';
import 'dart:math';

import 'package:bio_attendance/models/attendance_location.dart';
import 'package:bio_attendance/providers/database_provider.dart';
import 'package:bio_attendance/services/exceptions.dart';
import 'package:bio_attendance/utilities/dialogs/error_dialog.dart';
import 'package:bio_attendance/utilities/dialogs/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class LocationGeofenceScreen extends StatefulWidget {
  const LocationGeofenceScreen({super.key, required this.classLocation});

  final AttendanceLocation classLocation;

  @override
  State<LocationGeofenceScreen> createState() => _LocationGeofenceScreenState();
}

class _LocationGeofenceScreenState extends State<LocationGeofenceScreen> {
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  final Set<Polygon> _polygons = {};
  List<LatLng> _polygonLatLngs = [];
  late AttendanceLocation? _attLocation;

  @override
  void initState() {
    super.initState();

      _attLocation = widget.classLocation;

      if (_attLocation!.polygonPoints != null) {
        setState(() {
          _polygonLatLngs = _attLocation!.polygonPoints!;
          _markers = _attLocation!.polygonPoints!
              .map(
                (position) => Marker(
                  markerId: MarkerId(position.toString()),
                  position: position,
                  draggable: true,
                  infoWindow: InfoWindow(
                    title: position.toString(),
                    snippet: 'Tap to delete',
                    onTap: () => _removeMarker(MarkerId(position.toString())),
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueViolet,
                  ),
                  onDragEnd: (LatLng newPosition) => _updateMarker(
                    MarkerId(position.toString()),
                    newPosition,
                    position,
                  ),
                ),
              )
              .toSet();
          List<LatLng> sortedLatLngs = sortPoints(_polygonLatLngs);

          if (_polygonLatLngs.length >= 3) {
            _polygons.add(Polygon(
              polygonId: const PolygonId("New polygon"),
              points: sortedLatLngs,
              fillColor: const Color.fromARGB(255, 1, 30, 53).withOpacity(0.2),
              strokeColor: Colors.indigo,
              strokeWidth: 2,
            ));
          }
        });
      }
  }

  //* The Shoelace formula
  double calculatePolygonArea(List<LatLng> polygon) {
    double area = 0.0;
    int j = polygon.length - 1;
    for (int i = 0; i < polygon.length; i++) {
      area += (polygon[j].latitude + polygon[i].latitude) *
          (polygon[j].longitude - polygon[i].longitude);
      j = i;
    }

    //* Convert to m2 from km2
    return (area.abs() / 2.0) * 1000 * 1000;
  }

  LatLng getCentroid(List<LatLng> points) {
    double latitude = 0;
    double longitude = 0;
    int n = points.length;

    for (LatLng point in points) {
      latitude += point.latitude;
      longitude += point.longitude;
    }

    return LatLng(latitude / n, longitude / n);
  }

  List<LatLng> sortPoints(List<LatLng> points) {
    LatLng centroid = getCentroid(points);

    points.sort((a, b) {
      double aAngle = atan2(
          a.longitude - centroid.longitude, a.latitude - centroid.latitude);
      double bAngle = atan2(
          b.longitude - centroid.longitude, b.latitude - centroid.latitude);

      return aAngle.compareTo(bAngle);
    });

    return points;
  }

  //* Add geofence point
  void _addMarker(LatLng position) {
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId(position.toString()),
          position: position,
          draggable: true,
          infoWindow: InfoWindow(
              title: position.toString(),
              snippet: 'Tap to delete',
              onTap: () => _removeMarker(MarkerId(position.toString()))),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose),
          onDragEnd: (LatLng newPosition) => _updateMarker(
              MarkerId(position.toString()), newPosition, position),
        ),
      );
      _polygonLatLngs.add(position);
      List<LatLng> sortedLatLngs = sortPoints(_polygonLatLngs);
      if (_polygonLatLngs.length >= 3) {
        _polygons.add(Polygon(
          polygonId: const PolygonId("New polygon"),
          points: sortedLatLngs,
          fillColor: const Color.fromARGB(255, 1, 30, 53).withOpacity(0.2),
          strokeColor: Colors.indigo,
          strokeWidth: 2,
        ));
      }
    });
  }

  //* Update a geofence point
  void _updateMarker(
      MarkerId markerId, LatLng newPosition, LatLng oldPosition) {
    setState(() {
      Marker marker =
          _markers.firstWhere((marker) => marker.markerId == markerId);

      _polygonLatLngs.removeWhere((position) => position == marker.position);
      _markers.remove(marker);

      _polygons.clear();

      _addMarker(newPosition);
    });
  }

  //* Remove a marker from the map
  void _removeMarker(MarkerId markerId) {
    setState(() {
      Marker marker =
          _markers.firstWhere((marker) => marker.markerId == markerId);

      _polygonLatLngs.removeWhere((position) => position == marker.position);

      _markers.removeWhere((marker) => marker.markerId == markerId);

      _polygons.clear();

      List<LatLng> sortedLatLngs = sortPoints(_polygonLatLngs);

      _polygons.add(Polygon(
        polygonId: const PolygonId("New polygon"),
        points: sortedLatLngs,
        fillColor: const Color.fromARGB(255, 1, 30, 53).withOpacity(0.2),
        strokeColor: Colors.indigo,
        strokeWidth: 2,
      ));
    });
  }

  //* Clear all the markers from the geofence
  void _clearMarkers() {
    setState(() {
      _markers.clear();
      _polygons.clear();
      _polygonLatLngs.clear();
    });
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  //* Submit geofence data
  void _submitDetails(DatabaseProvider databaseProvider) async {
    if (_polygonLatLngs.length < 3 || _polygonLatLngs.length > 10) {
      showErrorDialog(context, 'Geofence must have 3 to 10 points');
      return;
    }

    try {
      await databaseProvider.updateClassLocation(
          _attLocation!.name, json.encode(_polygonLatLngs));

      if (!mounted) return;
      showSuccessDialog(context, 'Geofence points saved successfully');
    } on LocationNotFoundException {
      showErrorDialog(context, LocationNotFoundException().toString());
    } on GenericException {
      showErrorDialog(context, GenericException().toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_attLocation!.name),
      ),
      body: Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: getCentroid(_polygonLatLngs).latitude.isNaN
                        ? const LatLng(-1.2727898957836414, 36.80745340883732)
                        : getCentroid(_polygonLatLngs),
                    zoom: 15,
                  ),
                  markers: _markers,
                  polygons: _polygons,
                  onTap: _addMarker,
                  myLocationEnabled: true,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.indigo.withOpacity(.4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Area',
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            '${calculatePolygonArea(_polygonLatLngs)} km2',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton:
          Consumer<DatabaseProvider>(builder: (_, databaseProvider, __) {
        return databaseProvider.isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton.extended(
                    heroTag: 'Save detials button',
                    backgroundColor: Colors.teal.withOpacity(.7),
                    onPressed: () => _submitDetails(databaseProvider),
                    label: const Text(
                      'Save details',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton.extended(
                    heroTag: 'Clear map button',
                    backgroundColor: Colors.indigo.withOpacity(.7),
                    onPressed: _clearMarkers,
                    label: const Text(
                      'Clear map',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
