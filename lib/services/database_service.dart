import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/student_model.dart';
import '../models/faculty_model.dart';
import '../models/attendance_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get users => _firestore.collection('users');
  CollectionReference get students => _firestore.collection('students');
  CollectionReference get faculty => _firestore.collection('faculty');
  CollectionReference get attendance => _firestore.collection('attendance');
  CollectionReference get classes => _firestore.collection('classes');
  CollectionReference get subjects => _firestore.collection('subjects');

  // User operations
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      await users.doc(uid).set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = await users.doc(uid).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await users.doc(uid).update(updates);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String uid) async {
    try {
      await users.doc(uid).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Student operations
  Future<String> createStudent(Map<String, dynamic> studentData) async {
    try {
      DocumentReference docRef = await students.add({
        ...studentData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  Future<StudentModel?> getStudent(String studentId) async {
    try {
      DocumentSnapshot doc = await students.doc(studentId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get student: $e');
    }
  }

  Future<StudentModel?> getStudentByUSN(String usn) async {
    try {
      QuerySnapshot snapshot = await students
          .where('usn', isEqualTo: usn)
          .limit(1)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data, snapshot.docs.first.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get student by USN: $e');
    }
  }

  Future<List<StudentModel>> getAllStudents() async {
    try {
      QuerySnapshot snapshot = await students
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get students: $e');
    }
  }

  Future<List<StudentModel>> getStudentsByClass(String className, String section) async {
    try {
      QuerySnapshot snapshot = await students
          .where('className', isEqualTo: className)
          .where('section', isEqualTo: section)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get students by class: $e');
    }
  }

  Future<void> updateStudent(String studentId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await students.doc(studentId).update(updates);
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      await students.doc(studentId).delete();
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  // Faculty operations
  Future<String> createFaculty(Map<String, dynamic> facultyData) async {
    try {
      DocumentReference docRef = await faculty.add({
        ...facultyData,
        'createdAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });
      return docRef.id;
    } catch (e) {
      throw Exception('Failed to create faculty: $e');
    }
  }

  Future<FacultyModel?> getFaculty(String facultyId) async {
    try {
      DocumentSnapshot doc = await faculty.doc(facultyId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FacultyModel.fromMap(data, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get faculty: $e');
    }
  }

  Future<List<FacultyModel>> getAllFaculty() async {
    try {
      QuerySnapshot snapshot = await faculty
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FacultyModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get faculty: $e');
    }
  }

  Future<void> updateFaculty(String facultyId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await faculty.doc(facultyId).update(updates);
    } catch (e) {
      throw Exception('Failed to update faculty: $e');
    }
  }

  Future<void> deleteFaculty(String facultyId) async {
    try {
      await faculty.doc(facultyId).delete();
    } catch (e) {
      throw Exception('Failed to delete faculty: $e');
    }
  }

  // Attendance operations
  Future<void> markAttendance(String studentId, String date, Map<String, dynamic> attendanceData) async {
    try {
      String docId = '${studentId}_$date';
      await attendance.doc(docId).set({
        ...attendanceData,
        'markedAt': FieldValue.serverTimestamp(),
        'isVerified': false,
      });
    } catch (e) {
      throw Exception('Failed to mark attendance: $e');
    }
  }

  Future<AttendanceModel?> getAttendance(String studentId, String date) async {
    try {
      String docId = '${studentId}_$date';
      DocumentSnapshot doc = await attendance.doc(docId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AttendanceModel.fromMap(data, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get attendance: $e');
    }
  }

  Future<List<AttendanceModel>> getStudentAttendanceHistory(String studentId, {int limit = 30}) async {
    try {
      QuerySnapshot snapshot = await attendance
          .where('studentId', isEqualTo: studentId)
          .orderBy('date', descending: true)
          .limit(limit)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AttendanceModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get attendance history: $e');
    }
  }

  Future<List<AttendanceModel>> getClassAttendance(String className, String date) async {
    try {
      QuerySnapshot snapshot = await attendance
          .where('className', isEqualTo: className)
          .where('date', isEqualTo: date)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return AttendanceModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get class attendance: $e');
    }
  }

  Future<void> updateAttendance(String attendanceId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await attendance.doc(attendanceId).update(updates);
    } catch (e) {
      throw Exception('Failed to update attendance: $e');
    }
  }

  Future<void> deleteAttendance(String attendanceId) async {
    try {
      await attendance.doc(attendanceId).delete();
    } catch (e) {
      throw Exception('Failed to delete attendance: $e');
    }
  }

  // Batch operations
  Future<void> batchMarkAttendance(List<Map<String, dynamic>> attendanceRecords) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (var record in attendanceRecords) {
        String docId = '${record['studentId']}_${record['date']}';
        DocumentReference ref = attendance.doc(docId);
        batch.set(ref, {
          ...record,
          'markedAt': FieldValue.serverTimestamp(),
          'isVerified': false,
        });
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Batch attendance marking failed: $e');
    }
  }

  // Search operations
  Future<List<StudentModel>> searchStudents(String query) async {
    try {
      QuerySnapshot snapshot = await students
          .where('isActive', isEqualTo: true)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(20)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return StudentModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Student search failed: $e');
    }
  }

  Future<List<FacultyModel>> searchFaculty(String query) async {
    try {
      QuerySnapshot snapshot = await faculty
          .where('isActive', isEqualTo: true)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .limit(20)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return FacultyModel.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      throw Exception('Faculty search failed: $e');
    }
  }

  // Statistics and analytics
  Future<Map<String, dynamic>> getAttendanceStatistics(String studentId, String startDate, String endDate) async {
    try {
      QuerySnapshot snapshot = await attendance
          .where('studentId', isEqualTo: studentId)
          .where('date', isGreaterThanOrEqualTo: startDate)
          .where('date', isLessThanOrEqualTo: endDate)
          .get();
      
      int total = snapshot.docs.length;
      int present = 0;
      int absent = 0;
      int late = 0;
      int excused = 0;
      
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String status = data['status'] ?? 'absent';
        switch (status) {
          case 'present':
            present++;
            break;
          case 'absent':
            absent++;
            break;
          case 'late':
            late++;
            break;
          case 'excused':
            excused++;
            break;
        }
      }
      
      return {
        'total': total,
        'present': present,
        'absent': absent,
        'late': late,
        'excused': excused,
        'attendancePercentage': total > 0 ? ((present / total) * 100).roundToDouble() : 0.0,
      };
    } catch (e) {
      throw Exception('Failed to get attendance statistics: $e');
    }
  }

  // Real-time listeners
  Stream<QuerySnapshot> getStudentsStream() {
    return students
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  Stream<QuerySnapshot> getFacultyStream() {
    return faculty
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots();
  }

  Stream<QuerySnapshot> getAttendanceStream(String className) {
    return attendance
        .where('className', isEqualTo: className)
        .orderBy('date', descending: true)
        .snapshots();
  }

  // Data validation
  bool validateStudentData(Map<String, dynamic> data) {
    List<String> requiredFields = ['name', 'email', 'phone', 'className', 'section', 'dateOfBirth', 'gender', 'address'];
    
    for (String field in requiredFields) {
      if (data[field] == null || data[field].toString().trim().isEmpty) {
        return false;
      }
    }
    
    // Validate email format
    String email = data['email'].toString();
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    
    return true;
  }

  bool validateFacultyData(Map<String, dynamic> data) {
    List<String> requiredFields = ['name', 'email', 'phone', 'department', 'designation', 'dateOfBirth', 'gender', 'address', 'joiningDate'];
    
    for (String field in requiredFields) {
      if (data[field] == null || data[field].toString().trim().isEmpty) {
        return false;
      }
    }
    
    // Validate email format
    String email = data['email'].toString();
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    
    return true;
  }
} 