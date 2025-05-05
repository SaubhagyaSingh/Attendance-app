class ApiConstants {
  static String _baseUrl = 'https://bxmgxsx0-8000.inc1.devtunnels.ms';

  static String get baseUrl => _baseUrl;
  static const String uploadStudentFaceEndpoint = '/upload/add_student_face';
  static const String getStudentsEndpoint = '/students';

  static void setBaseUrl(String newUrl) {
    _baseUrl = newUrl;
  }
}
