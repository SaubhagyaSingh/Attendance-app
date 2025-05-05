class Student {
  final String id; // Using 'id' instead of '_id' for cleaner Dart naming
  final String name;
  final String prn;
  final String panel;
  final int panelRollNo;
  final String faceEncoding;
  final List<String> faces;

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
      faces: List<String>.from(json['faces'] as List<dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'prn': prn,
      'panel': panel,
      'panel_roll_no': panelRollNo,
      'face_encoding': faceEncoding,
      'faces': faces,
    };
  }
}
