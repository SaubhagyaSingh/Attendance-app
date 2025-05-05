import 'dart:convert';
import 'package:attendance_app/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class StudentService {
  Future<List<Student>> getStudents() async {
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/student/get_all_students'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }
}
