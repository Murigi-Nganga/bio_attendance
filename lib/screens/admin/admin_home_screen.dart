import 'package:bio_attendance/routes/app_routes.dart';
import 'package:bio_attendance/screens/admin/tabs/lecturers_tab.dart';
import 'package:bio_attendance/screens/admin/tabs/reports_tab.dart';
import 'package:bio_attendance/screens/admin/tabs/students_tab.dart';
import 'package:bio_attendance/services/local_storage.dart';
import 'package:bio_attendance/utilities/enums/app_enums.dart';
import 'package:flutter/material.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  void _handleLogout(BuildContext context) async {
    await LocalStorage().deleteUser();
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      loginRoute,
      (route) => false,
      arguments: {'role': Role.admin}
    );
  }

  int _currentIndex = 0;
  final _tabTitles = ['Students', 'Lecturers', 'Reports'];
  final _tabPages = const [
    StudentsTab(),
    LecturersTab(),
    ReportsTab(),
  ];

  final _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.school_rounded),
      label: 'Students',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_rounded),
      label: 'Lecturers',
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
