class Panel {
  final String id;
  final String panelLetter;
  final String school;
  final String specialization;
  final List<String> students;
  final List<String> semesters;
  final String currentSemester;

  Panel({
    required this.id,
    required this.panelLetter,
    required this.school,
    required this.specialization,
    required this.students,
    required this.semesters,
    required this.currentSemester,
  });

  factory Panel.fromJson(Map<String, dynamic> json) {
    return Panel(
      id: json['_id'] as String,
      panelLetter: json['panel_letter'] as String,
      school: json['school'] as String,
      specialization: json['specialization'] as String,
      students: List<String>.from(json['students'] as List<dynamic>),
      semesters: List<String>.from(json['semesters'] as List<dynamic>),
      currentSemester: json['current_semester'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'panel_letter': panelLetter,
      'school': school,
      'specialization': specialization,
      'students': students,
      'semesters': semesters,
      'current_semester': currentSemester,
    };
  }
}
