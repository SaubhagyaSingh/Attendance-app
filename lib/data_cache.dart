import 'models/room_model.dart';
import 'models/subject_model.dart';
import 'models/teacher_model.dart';
import 'models/panel_model.dart';
import 'services/room_service.dart';
import 'services/subject_service.dart';
import 'services/teacher_service.dart';
import 'services/panel_service.dart';

class DataCache {
  static final DataCache _instance = DataCache._internal();
  factory DataCache() => _instance;
  DataCache._internal();

  final RoomService _roomService = RoomService();
  final SubjectService _subjectService = SubjectService();
  final TeacherService _teacherService = TeacherService();
  final PanelService _panelService = PanelService();

  List<Room>? _rooms;
  List<Subject>? _subjects;
  List<Teacher>? _teachers;
  List<Panel>? _panels;

  Future<List<Room>> getRooms() async {
    if (_rooms == null || _rooms!.isEmpty) {
      print('Fetching rooms from API'); // Debug
      _rooms = await _roomService.getRooms();
    } else {
      print('Using cached rooms'); // Debug
    }
    return _rooms!;
  }

  Future<List<Subject>> getSubjects() async {
    if (_subjects == null || _subjects!.isEmpty) {
      print('Fetching subjects from API'); // Debug
      _subjects = await _subjectService.getSubjects();
    } else {
      print('Using cached subjects'); // Debug
    }
    return _subjects!;
  }

  Future<List<Teacher>> getTeachers() async {
    if (_teachers == null || _teachers!.isEmpty) {
      print('Fetching teachers from API'); // Debug
      _teachers = await _teacherService.getTeachers();
    } else {
      print('Using cached teachers'); // Debug
    }
    return _teachers!;
  }

  Future<List<Panel>> getPanels() async {
    if (_panels == null || _panels!.isEmpty) {
      print('Fetching panels from API'); // Debug
      _panels = await _panelService.getPanels();
    } else {
      print('Using cached panels'); // Debug
    }
    return _panels!;
  }

  // Optional: Clear cache if needed (e.g., for logout or refresh)
  void clearCache() {
    _rooms = null;
    _subjects = null;
    _teachers = null;
    _panels = null;
    print('Cache cleared'); // Debug
  }
}
