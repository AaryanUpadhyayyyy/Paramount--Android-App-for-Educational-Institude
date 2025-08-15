import 'package:cloud_firestore/cloud_firestore.dart';

class StudentModel {
  final String? id;
  final String usn;
  final String name;
  final String email;
  final String phone;
  final String className;
  final String section;
  final String? profileImageUrl;
  final DateTime dateOfBirth;
  final String gender;
  final String address;
  final String? parentName;
  final String? parentPhone;
  final String? parentEmail;
  final DateTime admissionDate;
  final bool isActive;
  final Map<String, dynamic>? academicDetails;

  StudentModel({
    this.id,
    required this.usn,
    required this.name,
    required this.email,
    required this.phone,
    required this.className,
    required this.section,
    this.profileImageUrl,
    required this.dateOfBirth,
    required this.gender,
    required this.address,
    this.parentName,
    this.parentPhone,
    this.parentEmail,
    required this.admissionDate,
    this.isActive = true,
    this.academicDetails,
  });

  factory StudentModel.fromMap(Map<String, dynamic> map, String documentId) {
    return StudentModel(
      id: documentId,
      usn: map['usn'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      className: map['className'] ?? '',
      section: map['section'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      dateOfBirth: (map['dateOfBirth'] as Timestamp).toDate(),
      gender: map['gender'] ?? '',
      address: map['address'] ?? '',
      parentName: map['parentName'],
      parentPhone: map['parentPhone'],
      parentEmail: map['parentEmail'],
      admissionDate: (map['admissionDate'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
      academicDetails: map['academicDetails'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'usn': usn,
      'name': name,
      'email': email,
      'phone': phone,
      'className': className,
      'section': section,
      'profileImageUrl': profileImageUrl,
      'dateOfBirth': Timestamp.fromDate(dateOfBirth),
      'gender': gender,
      'address': address,
      'parentName': parentName,
      'parentPhone': parentPhone,
      'parentEmail': parentEmail,
      'admissionDate': Timestamp.fromDate(admissionDate),
      'isActive': isActive,
      'academicDetails': academicDetails,
    };
  }

  StudentModel copyWith({
    String? id,
    String? usn,
    String? name,
    String? email,
    String? phone,
    String? className,
    String? section,
    String? profileImageUrl,
    DateTime? dateOfBirth,
    String? gender,
    String? address,
    String? parentName,
    String? parentPhone,
    String? parentEmail,
    DateTime? admissionDate,
    bool? isActive,
    Map<String, dynamic>? academicDetails,
  }) {
    return StudentModel(
      id: id ?? this.id,
      usn: usn ?? this.usn,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      className: className ?? this.className,
      section: section ?? this.section,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      parentName: parentName ?? this.parentName,
      parentPhone: parentPhone ?? this.parentPhone,
      parentEmail: parentEmail ?? this.parentEmail,
      admissionDate: admissionDate ?? this.admissionDate,
      isActive: isActive ?? this.isActive,
      academicDetails: academicDetails ?? this.academicDetails,
    );
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, usn: $usn, name: $name, className: $className, section: $section)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StudentModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
} 