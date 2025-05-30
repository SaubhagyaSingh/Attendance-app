import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import '../models/teacher_model.dart';

class TeacherService {
  Future<List<Teacher>> getTeachers() async {
    print(
        'Calling API: ${ApiConstants.baseUrl}/teachers/get_all_teachers'); // Debug
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/teachers/get_all_teachers'));
    print('API response: ${response.statusCode} - ${response.body}'); // Debug
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final teachers = data.map((json) => Teacher.fromJson(json)).toList();
      print(
          'Teachers fetched: ${teachers.map((t) => t.name).toList()}'); // Debug
      return teachers;
    } else {
      throw Exception(
          'Failed to load teachers: ${response.statusCode} - ${response.body}');
    }
  }
}
