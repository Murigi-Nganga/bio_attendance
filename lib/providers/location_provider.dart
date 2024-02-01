// import 'package:bio_attendance/models/attendance_location.dart';
// import 'package:flutter/material.dart';

// class LocationGeofenceProvider with ChangeNotifier {
//   List<AttendanceLocation> _locations = [];
//   AttendanceLocation? _selectedLocation;
//   bool _isChecked = false;
//   bool isLoading = false;

//   List<AttendanceLocation> get locations => _locations;
//   AttendanceLocation? get selectedLocation => _selectedLocation;
//   bool get isChecked => _isChecked;

//   LocationGeofenceProvider() {
//     getLocations();
//   }

//   Future<void> getLocations() async {
//     isLoading = true;
//     notifyListeners();

//     try {
//       await _databaseService.addStudent(addStudentData);
//     }

//     try {
//       await http.get(Uri.parse(Endpoints.getLocationsUrl)).then((response) {
//         final responseBody = json.decode(response.body);
//         if (response.statusCode == 200) {
//           final List<AttendanceLocation> locations = responseBody
//               .map<AttendanceLocation>(
//                   (obj) => AttendanceLocation.fromJson(obj))
//               .toList();
//           if (locations.isEmpty) {
//             change(locations, status: RxStatus.empty());
//             return;
//           }
//           change(locations, status: RxStatus.success());
//         } else {
//           change(null, status: RxStatus.error('Something went wrong'));
//         }
//       });
//     } catch (error) {
//       change(null, status: RxStatus.error(error.toString()));
//       showSnack(
//         'Error',
//         'Locations could not be fetched. Check your network connection',
//         Colors.red[400]!,
//         Icons.error_rounded,
//         1,
//       );
//     }
//   }

//   Future<void> updateLocation(String polygonPoints) async {
//     // Implement your updateLocation logic
//   }
// }
