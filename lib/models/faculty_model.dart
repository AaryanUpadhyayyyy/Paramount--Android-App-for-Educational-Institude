import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyModel {
  final String? id;
  final String employeeId;
  final String name;
  final String email;
  final String phone;
  final String department;
  final String designation;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final DateTime joiningDate;
  final List<String> subjects;
  final List<String> classes;
  final Map<String, dynamic>? qualifications;
  final bool isActive;
  final DateTime createdAt;

  FacultyModel({
    this.id,
    required this.employeeId,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.designation,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    required this.joiningDate,
    required this.subjects,
    required this.classes,
    this.qualifications,
    this.isActive = true,
    required this.createdAt,
  });

  factory FacultyModel.fromMap(Map<String, dynamic> map, String documentId) {
    return FacultyModel(
      id: documentId,
      employeeId: map['employeeId'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      department: map['department'] ?? '',
      designation: map['designation'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      joiningDate: (map['joiningDate'] as Timestamp).toDate(),
      subjects: List<String>.from(map['subjects'] ?? []),
      classes: List<String>.from(map['classes'] ?? []),
      qualifications: map['qualifications'],
      isActive: map['isActive'] ?? true,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'name': name,
      'email': email,
      'phone': phone,
      'department': department,
      'designation': designation,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'address': address,
      'joiningDate': Timestamp.fromDate(joiningDate),
      'subjects': subjects,
      'classes': classes,
      'qualifications': qualifications,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  FacultyModel copyWith({
    String? id,
    String? employeeId,
    String? name,
    String? email,
    String? phone,
    String? department,
    String? designation,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    DateTime? joiningDate,
    List<String>? subjects,
    List<String>? classes,
    Map<String, dynamic>? qualifications,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return FacultyModel(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      designation: designation ?? this.designation,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      joiningDate: joiningDate ?? this.joiningDate,
      subjects: subjects ?? this.subjects,
      classes: classes ?? this.classes,
      qualifications: qualifications ?? this.qualifications,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'FacultyModel(id: $id, employeeId: $employeeId, name: $name, department: $department, designation: $designation)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FacultyModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 