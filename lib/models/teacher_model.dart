class Teacher {
  final String id;
  final String name;
  final String? email;
  final List<String>? subjects;
  final List<String>? panels;

  Teacher({
    required this.id,
    required this.name,
    this.email,
    this.subjects,
    this.panels,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      subjects: json['subjects'] != null
          ? List<String>.from(json['subjects'] as List<dynamic>)
          : null,
      panels: json['panels'] != null
          ? List<String>.from(json['panels'] as List<dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'subjects': subjects,
      'panels': panels,
    };
  }
}
