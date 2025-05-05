import 'dart:convert';
import 'package:attendance_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class AttendanceService {
  Future<http.Response> addAttendance({
    required String roomId,
    required String subjectId,
    required String teacherId,
    required String panelId,
    required String startTime,
    required String date,
    required String endTime,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}/upload/add_attendance');
    final body = jsonEncode({
      'room': roomId,
      'subject': subjectId,
      'teacher': teacherId,
      'panel': panelId,
      'start_time': startTime,
      'date': date,
      'end_time': endTime,
    });

    // Log request details
    print('Sending attendance to: $uri');
    print('Request body: $body');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    // Log response details
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    return response;
  }
}
