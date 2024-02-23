import 'package:bio_attendance/router/app_router.dart';
import 'package:bio_attendance/screens/lecturer/tabs/course_units_tab.dart';
import 'package:bio_attendance/screens/lecturer/tabs/reports_tab.dart';
import 'package:bio_attendance/screens/lecturer/tabs/class_locations_tab.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:flutter/material.dart';

class LecturerHomeScreen extends StatefulWidget {
  const LecturerHomeScreen({super.key});

  @override
  State<LecturerHomeScreen> createState() => _LecturerHomeScreenState();
}

class _LecturerHomeScreenState extends State<LecturerHomeScreen> {
  void _handleLogout(BuildContext context) async {
    await LocalStorage().deleteUser();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRouter.userSelectionRoute,
      (route) => false,
    );
  }

int _currentIndex = 0;

  final _tabTitles = ['Course Units', 'Locations', 'Reports'];

  final _tabPages = const [
    CourseUnitsTab(),
    ClassLocationsTab(),
    ReportsTab(),
  ];

  final _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.my_library_books_rounded),
      label: 'Units',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.location_pin),
      label: 'Locations',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.menu_book_rounded),
      label: 'Reports',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.power_settings_new_rounded),
      label: 'Log Out',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tabTitles[_currentIndex]),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _tabPages[_currentIndex],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == _bottomNavBarItems.length - 1) {
            _handleLogout(context);
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: _bottomNavBarItems,
      ),
    );
  }
}
