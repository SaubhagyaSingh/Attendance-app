class Student {
  final String studentId;
  final String faceImageUrl;

  Student({required this.studentId, required this.faceImageUrl});

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentId: json['student_id'],
      faceImageUrl: json['face_image_url'],
    );
  }
}
