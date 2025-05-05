import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../data_cache.dart';
import '../models/room_model.dart';
import '../models/subject_model.dart';
import '../models/teacher_model.dart';
import '../models/panel_model.dart';
import '../models/lecture_result_model.dart';
import '../services/attendance_service.dart';

class GetAttendanceView extends StatefulWidget {
  final CameraDescription camera;

  const GetAttendanceView({super.key, required this.camera});

  @override
  _GetAttendanceViewState createState() => _GetAttendanceViewState();
}

class _GetAttendanceViewState extends State<GetAttendanceView> {
  final DataCache _dataCache = DataCache();
  final AttendanceService _attendanceService = AttendanceService();
  final _formKey = GlobalKey<FormState>();

  List<Room> _rooms = [];
  List<Subject> _subjects = [];
  List<Teacher> _teachers = [];
  List<Panel> _panels = [];
  Room? _selectedRoom;
  Subject? _selectedSubject;
  Teacher? _selectedTeacher;
  Panel? _selectedPanel;
  LectureResult? _lectureResult;
  bool _isLoading = false;
  String? _startTime;
  String? _date;
  String? _endTime;

  final _startTimeController = TextEditingController();
  final _dateController = TextEditingController();
  final _endTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    print('GetAttendanceView initialized'); // Debug
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final rooms = await _dataCache.getRooms();
      final subjects = await _dataCache.getSubjects();
      final teachers = await _dataCache.getTeachers();
      final panels = await _dataCache.getPanels();
      setState(() {
        _rooms = rooms;
        _subjects = subjects;
        _teachers = teachers;
        _panels = panels;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e'); // Debug
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  Future<void> _submitForm() async {
    print('Submitting form...'); // Debug
    if (_formKey.currentState!.validate() &&
        _selectedRoom != null &&
        _selectedSubject != null &&
        _selectedTeacher != null &&
        _selectedPanel != null) {
      // Log form data
      print('Form data:');
      print('  roomId: ${_selectedRoom!.id}');
      print('  subjectId: ${_selectedSubject!.id}');
      print('  teacherId: ${_selectedTeacher!.id}');
      print('  panelId: ${_selectedPanel!.id}');
      print('  startTime: $_startTime');
      print('  date: $_date');
      print('  endTime: $_endTime');

      setState(() => _isLoading = true);
      try {
        final response = await _attendanceService.addAttendance(
          roomId: _selectedRoom!.id,
          subjectId: _selectedSubject!.id,
          teacherId: _selectedTeacher!.id,
          panelId: _selectedPanel!.id,
          startTime: _startTime!,
          date: _date!,
          endTime: _endTime!,
        );
        print(
            'Attendance response: ${response.statusCode} - ${response.body}'); // Debug
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          setState(() {
            _lectureResult = LectureResult.fromJson(jsonData);
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Attendance submitted successfully')),
          );
          // Clear form
          _formKey.currentState!.reset();
          _startTimeController.clear();
          _dateController.clear();
          _endTimeController.clear();
          setState(() {
            _selectedRoom = null;
            _selectedSubject = null;
            _selectedTeacher = null;
            _selectedPanel = null;
          });
        } else {
          throw Exception(
              'Failed to submit attendance: ${response.statusCode} - ${response.body}');
        }
      } catch (e) {
        print('Error submitting attendance: $e'); // Debug
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error submitting attendance: $e')),
        );
      }
    } else {
      print('Form validation failed or missing selections'); // Debug
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please complete all fields and selections')),
      );
    }
  }

  void _clearResults() {
    setState(() {
      _lectureResult = null;
    });
    print('Lecture results cleared'); // Debug
  }

  @override
  void dispose() {
    _startTimeController.dispose();
    _dateController.dispose();
    _endTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building GetAttendanceView...'); // Debug
    return Scaffold(
      appBar: AppBar(title: const Text('Get Attendance')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Column(
                          children: [
                            DropdownButtonFormField<Room>(
                              decoration: const InputDecoration(
                                  labelText: 'Select Room'),
                              value: _selectedRoom,
                              isExpanded: true,
                              items: _rooms.map((Room room) {
                                return DropdownMenuItem<Room>(
                                  value: room,
                                  child: Text(room.name),
                                );
                              }).toList(),
                              onChanged: (Room? newValue) {
                                setState(() {
                                  _selectedRoom = newValue;
                                  print(
                                      'Selected room: ${newValue?.name}'); // Debug
                                });
                              },
                              validator: (value) =>
                                  value == null ? 'Please select a room' : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Subject>(
                              decoration: const InputDecoration(
                                  labelText: 'Select Subject'),
                              value: _selectedSubject,
                              isExpanded: true,
                              items: _subjects.map((Subject subject) {
                                return DropdownMenuItem<Subject>(
                                  value: subject,
                                  child: Text(
                                      '${subject.name} (${subject.subjectCode ?? ''})'),
                                );
                              }).toList(),
                              onChanged: (Subject? newValue) {
                                setState(() {
                                  _selectedSubject = newValue;
                                  print(
                                      'Selected subject: ${newValue?.name}'); // Debug
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select a subject'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Teacher>(
                              decoration: const InputDecoration(
                                  labelText: 'Select Teacher'),
                              value: _selectedTeacher,
                              isExpanded: true,
                              items: _teachers.map((Teacher teacher) {
                                return DropdownMenuItem<Teacher>(
                                  value: teacher,
                                  child: Text(teacher.name),
                                );
                              }).toList(),
                              onChanged: (Teacher? newValue) {
                                setState(() {
                                  _selectedTeacher = newValue;
                                  print(
                                      'Selected teacher: ${newValue?.name}'); // Debug
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select a teacher'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<Panel>(
                              decoration: const InputDecoration(
                                  labelText: 'Select Panel'),
                              value: _selectedPanel,
                              isExpanded: true,
                              items: _panels.map((Panel panel) {
                                return DropdownMenuItem<Panel>(
                                  value: panel,
                                  child: Text(
                                      '${panel.panelLetter} (${panel.specialization.isEmpty ? panel.school : panel.specialization})'),
                                );
                              }).toList(),
                              onChanged: (Panel? newValue) {
                                setState(() {
                                  _selectedPanel = newValue;
                                  print(
                                      'Selected panel: ${newValue?.panelLetter}'); // Debug
                                });
                              },
                              validator: (value) => value == null
                                  ? 'Please select a panel'
                                  : null,
                            ),
                          ],
                        ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _startTimeController,
                    decoration:
                        const InputDecoration(labelText: 'Start Time (HH:MM)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a start time';
                      }
                      final regex = RegExp(r'^\d{2}:\d{2}$');
                      if (!regex.hasMatch(value)) {
                        return 'Enter time in HH:MM format';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _startTime = value;
                      print('Start time entered: $value'); // Debug
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dateController,
                    decoration:
                        const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a date';
                      }
                      final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                      if (!regex.hasMatch(value)) {
                        return 'Enter date in YYYY-MM-DD format';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _date = value;
                      print('Date entered: $value'); // Debug
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _endTimeController,
                    decoration:
                        const InputDecoration(labelText: 'End Time (HH:MM)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an end time';
                      }
                      final regex = RegExp(r'^\d{2}:\d{2}$');
                      if (!regex.hasMatch(value)) {
                        return 'Enter time in HH:MM format';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _endTime = value;
                      print('End time entered: $value'); // Debug
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Get Attendance'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (_lectureResult != null) ...[
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attendance Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text('Present: ${_lectureResult!.present.length}'),
                      Text('Absent: ${_lectureResult!.absent.length}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_lectureResult!.present.isNotEmpty) ...[
                Text(
                  'Present Students',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('PRN')),
                      DataColumn(label: Text('Panel')),
                      DataColumn(label: Text('Panel Roll No')),
                    ],
                    rows: _lectureResult!.present.map((student) {
                      return DataRow(cells: [
                        DataCell(Text(student.name)),
                        DataCell(Text(student.prn)),
                        DataCell(Text(student.panel)),
                        DataCell(Text(student.panelRollNo.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (_lectureResult!.absent.isNotEmpty) ...[
                Text(
                  'Absent Students',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('PRN')),
                      DataColumn(label: Text('Panel')),
                      DataColumn(label: Text('Roll No')),
                    ],
                    rows: _lectureResult!.absent.map((student) {
                      return DataRow(cells: [
                        DataCell(Text(student.name)),
                        DataCell(Text(student.prn)),
                        DataCell(Text(student.panel)),
                        DataCell(Text(student.panelRollNo.toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}
