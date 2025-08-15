import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String? id;
  final String studentId;
  final String studentName;
  final String studentUSN;
  final String className;
  final String section;
  final String subject;
  final String facultyId;
  final String facultyName;
  final DateTime date;
  final String status; // 'present', 'absent', 'late', 'excused'
  final String? remarks;
  final DateTime markedAt;
  final String markedBy;
  final bool isVerified;

  AttendanceModel({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.studentUSN,
    required this.className,
    required this.section,
    required this.subject,
    required this.facultyId,
    required this.facultyName,
    required this.date,
    required this.status,
    this.remarks,
    required this.markedAt,
    required this.markedBy,
    this.isVerified = false,
  });

  factory AttendanceModel.fromMap(Map<String, dynamic> map, String documentId) {
    return AttendanceModel(
      id: documentId,
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentUSN: map['studentUSN'] ?? '',
      className: map['className'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      facultyId: map['facultyId'] ?? '',
      facultyName: map['facultyName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'] ?? '',
      remarks: map['remarks'],
      markedAt: (map['markedAt'] as Timestamp).toDate(),
      markedBy: map['markedBy'] ?? '',
      isVerified: map['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'studentName': studentName,
      'studentUSN': studentUSN,
      'className': className,
      'section': section,
      'subject': subject,
      'facultyId': facultyId,
      'facultyName': facultyName,
      'date': Timestamp.fromDate(date),
      'status': status,
      'remarks': remarks,
      'markedAt': Timestamp.fromDate(markedAt),
      'markedBy': markedBy,
      'isVerified': isVerified,
    };
  }

  AttendanceModel copyWith({
    String? id,
    String? studentId,
    String? studentName,
    String? studentUSN,
    String? className,
    String? section,
    String? subject,
    String? facultyId,
    String? facultyName,
    DateTime? date,
    String? status,
    String? remarks,
    DateTime? markedAt,
    String? markedBy,
    bool? isVerified,
  }) {
    return AttendanceModel(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      studentName: studentName ?? this.studentName,
      studentUSN: studentUSN ?? this.studentUSN,
      className: className ?? this.className,
      section: section ?? this.section,
      subject: subject ?? this.subject,
      facultyId: facultyId ?? this.facultyId,
      facultyName: facultyName ?? this.facultyName,
      date: date ?? this.date,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      markedAt: markedAt ?? this.markedAt,
      markedBy: markedBy ?? this.markedBy,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  @override
  String toString() {
    return 'AttendanceModel(id: $id, studentName: $studentName, date: $date, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttendanceModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Class for batch attendance operations
class ClassAttendanceModel {
  final String className;
  final String section;
  final String subject;
  final String facultyId;
  final String facultyName;
  final DateTime date;
  final List<AttendanceModel> attendanceRecords;
  final DateTime createdAt;
  final String createdBy;

  ClassAttendanceModel({
    required this.className,
    required this.section,
    required this.subject,
    required this.facultyId,
    required this.facultyName,
    required this.date,
    required this.attendanceRecords,
    required this.createdAt,
    required this.createdBy,
  });

  Map<String, dynamic> toMap() {
    return {
      'className': className,
      'section': section,
      'subject': subject,
      'facultyId': facultyId,
      'facultyName': facultyName,
      'date': Timestamp.fromDate(date),
      'attendanceRecords': attendanceRecords.map((record) => record.toMap()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'createdBy': createdBy,
    };
  }

  factory ClassAttendanceModel.fromMap(Map<String, dynamic> map) {
    return ClassAttendanceModel(
      className: map['className'] ?? '',
      section: map['section'] ?? '',
      subject: map['subject'] ?? '',
      facultyId: map['facultyId'] ?? '',
      facultyName: map['facultyName'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      attendanceRecords: (map['attendanceRecords'] as List)
          .map((record) => AttendanceModel.fromMap(record, ''))
          .toList(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      createdBy: map['createdBy'] ?? '',
    );
  }
} 