import 'package:attendance_app/views/class_view.dart';
import 'package:attendance_app/views/get_attendance_view.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'home_tab_view.dart';

class MainScreenView extends StatefulWidget {
  final CameraDescription camera;

  const MainScreenView({super.key, required this.camera});

  @override
  _MainScreenViewState createState() => _MainScreenViewState();
}

class _MainScreenViewState extends State<MainScreenView> {
  int _selectedIndex = 0;
  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      HomeTabView(camera: widget.camera),
      ClassView(camera: widget.camera),
      GetAttendanceView(camera: widget.camera)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Class'),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_box), label: 'Attendance'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PlaceholderTab extends StatelessWidget {
  final String title;

  const PlaceholderTab({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Content')),
    );
  }
}
