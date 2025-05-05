class Subject {
  final String id;
  final String name;
  final String subjectCode; // Add subjectCode field

  Subject({
    required this.id,
    required this.name,
    required this.subjectCode,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      id: json['_id'] as String,
      name: json['name'] as String,
      subjectCode: json['subject_code'] as String? ?? '', // Handle null case
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'subject_code': subjectCode,
    };
  }
}
