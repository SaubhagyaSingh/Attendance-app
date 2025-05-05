import 'package:attendance_app/constants/constants.dart';
import 'package:http/http.dart' as http;

class ClassPhotoService {
  Future<http.Response> uploadClassPhoto({
    required String roomId,
    required String date,
    required String time,
    required String imagePath,
  }) async {
    final uri =
        Uri.parse('${ApiConstants.baseUrl}/upload/add_class_photo').replace(
      queryParameters: {
        'room_id': roomId,
        'date': date,
        'time': time,
      },
    );
    final request = http.MultipartRequest('POST', uri);
    final file = await http.MultipartFile.fromPath('class_photo', imagePath);
    request.files.add(file);

    // Log the payload details
    print('Uploading class photo to: $uri');
    print('Query parameters: room_id=$roomId, date=$date, time=$time');
    print(
        'File: class_photo, path=$imagePath, size=${await file.length} bytes');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print(
        'Response: ${response.statusCode} - ${response.body}'); // Log response

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception(
          'Failed to upload class photo: ${response.statusCode} - ${response.body}');
    }
  }
}
