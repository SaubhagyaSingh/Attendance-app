import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  Future<http.StreamedResponse> uploadStudentFace({
    required String studentId,
    required File imageFile,
  }) async {
    var uri = Uri.parse(
      'https://bxmgxsx0-8000.inc1.devtunnels.ms/upload/add_student_face?student_id=$studentId',
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
    var uri = Uri.parse('https://bxmgxsx0-8000.inc1.devtunnels.ms/students');
    var request = http.Request('GET', uri);
    return request.send();
  }
}
