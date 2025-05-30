import 'dart:convert';
import 'package:attendance_app/constants/constants.dart';
import 'package:http/http.dart' as http;
import '../models/subject_model.dart';

class SubjectService {
  Future<List<Subject>> getSubjects() async {
    print(
        'Calling API: ${ApiConstants.baseUrl}/subjects/get_all_subjects'); // Debug
    final response = await http
        .get(Uri.parse('${ApiConstants.baseUrl}/subjects/get_all_subjects'));
    print('API response: ${response.statusCode} - ${response.body}'); // Debug
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Subject.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load subjects: ${response.statusCode} - ${response.body}');
    }
  }
}
