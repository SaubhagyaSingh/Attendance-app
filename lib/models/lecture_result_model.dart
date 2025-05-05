class LectureResult {
  List<Student> present;
  List<Student> absent;

  LectureResult({
    required this.present,
    required this.absent,
  });

  factory LectureResult.fromJson(Map<String, dynamic> json) {
    return LectureResult(
      present:
          (json['present'] as List).map((e) => Student.fromJson(e)).toList(),
      absent: (json['absent'] as List).map((e) => Student.fromJson(e)).toList(),
    );
  }
}

class Student {
  String id;
  String name;
  String prn;
  String panel;
  int panelRollNo;
  String faceEncoding;
  List<String> faces;

  Student({
    required this.id,
    required this.name,
    required this.prn,
    required this.panel,
    required this.panelRollNo,
    required this.faceEncoding,
    required this.faces,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'] as String,
      name: json['name'] as String,
      prn: json['prn'] as String,
      panel: json['panel'] as String,
      panelRollNo: json['panel_roll_no'] as int,
      faceEncoding: json['face_encoding'] as String,
      faces: (json['faces'] as List).cast<String>(),
    );
  }
}
