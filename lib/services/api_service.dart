import 'dart:io';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';

class ApiService {
  Future<http.StreamedResponse> uploadStudentFace({
    required String studentId,
    required File imageFile,
  }) async {
    var uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.uploadStudentFaceEndpoint}?student_id=$studentId',
    );
    var request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'face_image',
        await imageFile.readAsBytes(),
        filename: imageFile.path.split('/').last,
      ),
    );

    return request.send();
  }

  Future<http.StreamedResponse> getStudents() async {
    var uri = Uri.parse(
      '${ApiConstants.baseUrl}${ApiConstants.getStudentsEndpoint}',
    );
    var request = http.Request('GET', uri);
    return request.send();
  }
}
