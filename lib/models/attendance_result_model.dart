class AttendanceResult {
  final bool success;
  final List<StudentAttendance> attendance;
  final ClassDetails classDetails;

  AttendanceResult({
    required this.success,
    required this.attendance,
    required this.classDetails,
  });

  factory AttendanceResult.fromJson(Map<String, dynamic> json) {
    return AttendanceResult(
      success: json['success'] as bool,
      attendance: (json['attendance'] as List<dynamic>)
          .map((item) => StudentAttendance.fromJson(item))
          .toList(),
      classDetails:
          ClassDetails.fromJson(json['class_details'] as Map<String, dynamic>),
    );
  }
}

class StudentAttendance {
  final String studentId;
  final String name;
  final String prn;
  final String status;

  StudentAttendance({
    required this.studentId,
    required this.name,
    required this.prn,
    required this.status,
  });

  factory StudentAttendance.fromJson(Map<String, dynamic> json) {
    return StudentAttendance(
      studentId: json['student_id'] as String,
      name: json['name'] as String,
      prn: json['prn'] as String,
      status: json['status'] as String,
    );
  }
}

class ClassDetails {
  final String room;
  final String subject;
  final String teacher;
  final String panel;
  final String date;
  final String startTime;
  final String endTime;

  ClassDetails({
    required this.room,
    required this.subject,
    required this.teacher,
    required this.panel,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      room: json['room'] as String,
      subject: json['subject'] as String,
      teacher: json['teacher'] as String,
      panel: json['panel'] as String,
      date: json['date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }
}
