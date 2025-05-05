import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../models/student_model.dart';
import '../services/student_service.dart';
import 'upload_student_face_view.dart';

class HomeTabView extends StatefulWidget {
  final CameraDescription camera;

  const HomeTabView({super.key, required this.camera});

  @override
  _HomeTabViewState createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<HomeTabView> {
  final StudentService _studentService = StudentService();
  List<Student> _students = [];
  Student? _selectedStudent;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() => _isLoading = true);
    try {
      final students = await _studentService.getStudents();
      setState(() {
        _students = students;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching students: $e'); // Debug
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching students: $e')),
      );
    }
  }

  void _navigateToUpload() {
    if (_selectedStudent != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UploadStudentFaceView(
            studentId: _selectedStudent!.id, // Use 'id' from new model
            camera: widget.camera,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a student')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading
                ? const CircularProgressIndicator()
                : DropdownButton<Student>(
                    hint: const Text('Select a student'),
                    value: _selectedStudent,
                    isExpanded: true,
                    items: _students.map((Student student) {
                      return DropdownMenuItem<Student>(
                        value: student,
                        child: Text(
                            '${student.name} (${student.prn})'), // Display name and PRN
                      );
                    }).toList(),
                    onChanged: (Student? newValue) {
                      setState(() {
                        _selectedStudent = newValue;
                      });
                    },
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToUpload,
              child: const Text('Add Student Image'),
            ),
          ],
        ),
      ),
    );
  }
}
