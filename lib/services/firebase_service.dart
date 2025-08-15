import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication methods
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      throw Exception('User creation failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // User management methods
  Future<void> createUserProfile(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // Student management methods
  Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      await _firestore.collection('students').add(studentData);
    } catch (e) {
      throw Exception('Failed to add student: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllStudents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('students').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get students: $e');
    }
  }

  Future<Map<String, dynamic>?> getStudentByUSN(String usn) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('usn', isEqualTo: usn)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        Map<String, dynamic> data = snapshot.docs.first.data() as Map<String, dynamic>;
        data['id'] = snapshot.docs.first.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get student: $e');
    }
  }

  Future<void> updateStudent(String studentId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('students').doc(studentId).update(updates);
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  Future<void> deleteStudent(String studentId) async {
    try {
      await _firestore.collection('students').doc(studentId).delete();
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }

  // Faculty management methods
  Future<void> addFaculty(Map<String, dynamic> facultyData) async {
    try {
      await _firestore.collection('faculty').add(facultyData);
    } catch (e) {
      throw Exception('Failed to add faculty: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllFaculty() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('faculty').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get faculty: $e');
    }
  }

  Future<Map<String, dynamic>?> getFacultyById(String facultyId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('faculty').doc(facultyId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get faculty: $e');
    }
  }

  Future<void> updateFaculty(String facultyId, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('faculty').doc(facultyId).update(updates);
    } catch (e) {
      throw Exception('Failed to update faculty: $e');
    }
  }

  Future<void> deleteFaculty(String facultyId) async {
    try {
      await _firestore.collection('faculty').doc(facultyId).delete();
    } catch (e) {
      throw Exception('Failed to delete faculty: $e');
    }
  }

  // Attendance management methods
  Future<void> markAttendance(Map<String, dynamic> attendanceData) async {
    try {
      String docId = '${attendanceData['studentId']}_${attendanceData['date']}';
      await _firestore.collection('attendance').doc(docId).set(attendanceData);
    } catch (e) {
      throw Exception('Failed to mark attendance: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceByDate(String date) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('date', isEqualTo: date)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get attendance: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAttendanceByClass(String className) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('attendance')
          .where('className', isEqualTo: className)
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Failed to get class attendance: $e');
    }
  }

  // Note: File upload methods have been removed - use CloudinaryService instead
  // For file operations, import and use CloudinaryService:
  // import '../services/cloudinary_service.dart';
  // final cloudinary = CloudinaryService();

  // Real-time listeners
  Stream<QuerySnapshot> getStudentsStream() {
    return _firestore.collection('students').snapshots();
  }

  Stream<QuerySnapshot> getFacultyStream() {
    return _firestore.collection('faculty').snapshots();
  }

  Stream<QuerySnapshot> getAttendanceStream(String className) {
    return _firestore
        .collection('attendance')
        .where('className', isEqualTo: className)
        .snapshots();
  }

  // Batch operations
  Future<void> batchUpdateAttendance(List<Map<String, dynamic>> attendanceRecords) async {
    try {
      WriteBatch batch = _firestore.batch();
      
      for (var record in attendanceRecords) {
        String docId = '${record['studentId']}_${record['date']}';
        DocumentReference ref = _firestore.collection('attendance').doc(docId);
        batch.set(ref, record);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Batch update failed: $e');
    }
  }

  // Search methods
  Future<List<Map<String, dynamic>>> searchStudents(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('students')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> searchFaculty(String query) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('faculty')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .get();
      
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }
} 