import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/student_model.dart';

class StudentService {
  static const String baseUrl = 'https://bxmgxsx0-8000.inc1.devtunnels.ms';

  Future<List<Student>> getStudents() async {
    final response =
        await http.get(Uri.parse('$baseUrl/student/get_all_students'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Student.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load students: ${response.statusCode}');
    }
  }
}
