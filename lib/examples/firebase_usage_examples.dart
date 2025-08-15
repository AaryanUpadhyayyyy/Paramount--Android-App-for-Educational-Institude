import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../services/cloudinary_service.dart'; // Updated to use Cloudinary
import '../models/student_model.dart';
import '../models/faculty_model.dart';
import '../models/attendance_model.dart';

class FirebaseUsageExamples extends StatefulWidget {
  const FirebaseUsageExamples({Key? key}) : super(key: key);

  @override
  State<FirebaseUsageExamples> createState() => _FirebaseUsageExamplesState();
}

class _FirebaseUsageExamplesState extends State<FirebaseUsageExamples> {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final CloudinaryService _cloudinaryService = CloudinaryService(); // Updated

  String _status = 'Ready';
  List<StudentModel> _students = [];
  List<FacultyModel> _faculty = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase + Cloudinary Usage Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Status: $_status',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            
            // Authentication Examples
            _buildSection('Authentication', [
              ElevatedButton(
                onPressed: _signInExample,
                child: const Text('Sign In Example'),
              ),
              ElevatedButton(
                onPressed: _signUpExample,
                child: const Text('Sign Up Example'),
              ),
              ElevatedButton(
                onPressed: _signOutExample,
                child: const Text('Sign Out'),
              ),
              ElevatedButton(
                onPressed: _resetPasswordExample,
                child: const Text('Reset Password'),
              ),
            ]),

            // Database Examples
            _buildSection('Database Operations', [
              ElevatedButton(
                onPressed: _addStudentExample,
                child: const Text('Add Student Example'),
              ),
              ElevatedButton(
                onPressed: _getStudentsExample,
                child: const Text('Get All Students'),
              ),
              ElevatedButton(
                onPressed: _addFacultyExample,
                child: const Text('Add Faculty Example'),
              ),
              ElevatedButton(
                onPressed: _getFacultyExample,
                child: const Text('Get All Faculty'),
              ),
              ElevatedButton(
                onPressed: _markAttendanceExample,
                child: const Text('Mark Attendance Example'),
              ),
            ]),

            // Cloudinary Examples (replaces Firebase Storage)
            _buildSection('File Storage (Cloudinary)', [
              ElevatedButton(
                onPressed: _uploadProfileImageExample,
                child: const Text('Upload Profile Image'),
              ),
              ElevatedButton(
                onPressed: _uploadDocumentExample,
                child: const Text('Upload Document'),
              ),
              ElevatedButton(
                onPressed: _uploadAttendanceSheetExample,
                child: const Text('Upload Attendance Sheet'),
              ),
              ElevatedButton(
                onPressed: _pickAndUploadImageExample,
                child: const Text('Pick & Upload Image'),
              ),
              ElevatedButton(
                onPressed: _captureAndUploadImageExample,
                child: const Text('Capture & Upload Image'),
              ),
            ]),

            // Search Examples
            _buildSection('Search Operations', [
              ElevatedButton(
                onPressed: _searchStudentsExample,
                child: const Text('Search Students'),
              ),
              ElevatedButton(
                onPressed: _searchFacultyExample,
                child: const Text('Search Faculty'),
              ),
            ]),

            // Statistics Examples
            _buildSection('Statistics & Analytics', [
              ElevatedButton(
                onPressed: _getAttendanceStatsExample,
                child: const Text('Get Attendance Statistics'),
              ),
            ]),

            // Display Results
            if (_students.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSection('Students', [
                ..._students.map((student) => ListTile(
                  title: Text(student.name),
                  subtitle: Text('${student.className} - ${student.section}'),
                  trailing: Text(student.usn),
                )),
              ]),
            ],

            if (_faculty.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildSection('Faculty', [
                ..._faculty.map((faculty) => ListTile(
                  title: Text(faculty.name),
                  subtitle: Text('${faculty.department} - ${faculty.designation}'),
                  trailing: Text(faculty.employeeId),
                )),
              ]),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: child,
        )),
        const SizedBox(height: 20),
      ],
    );
  }

  // Authentication Examples
  Future<void> _signInExample() async {
    setState(() => _status = 'Signing in...');
    try {
      await _authService.signInWithEmailAndPassword(
        'teacher@example.com',
        'password123',
      );
      setState(() => _status = 'Signed in successfully!');
    } catch (e) {
      setState(() => _status = 'Sign in failed: $e');
    }
  }

  Future<void> _signUpExample() async {
    setState(() => _status = 'Creating account...');
    try {
      await _authService.createUserWithEmailAndPassword(
        'newuser@example.com',
        'password123',
        {
          'name': 'New User',
          'role': 'student',
          'usn': 'USN001',
        },
      );
      setState(() => _status = 'Account created successfully!');
    } catch (e) {
      setState(() => _status = 'Account creation failed: $e');
    }
  }

  Future<void> _signOutExample() async {
    setState(() => _status = 'Signing out...');
    try {
      await _authService.signOut();
      setState(() => _status = 'Signed out successfully!');
    } catch (e) {
      setState(() => _status = 'Sign out failed: $e');
    }
  }

  Future<void> _resetPasswordExample() async {
    setState(() => _status = 'Sending reset email...');
    try {
      await _authService.resetPassword('user@example.com');
      setState(() => _status = 'Password reset email sent!');
    } catch (e) {
      setState(() => _status = 'Password reset failed: $e');
    }
  }

  // Database Examples
  Future<void> _addStudentExample() async {
    setState(() => _status = 'Adding student...');
    try {
      String studentId = await _databaseService.createStudent({
        'usn': 'USN001',
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'phone': '+1234567890',
        'className': '10th',
        'section': 'A',
        'dateOfBirth': DateTime(2005, 1, 1),
        'gender': 'Male',
        'address': '123 Main St, City, State',
        'parentName': 'Jane Doe',
        'parentPhone': '+1234567891',
        'parentEmail': 'jane.doe@example.com',
        'admissionDate': DateTime.now(),
      });
      setState(() => _status = 'Student added with ID: $studentId');
    } catch (e) {
      setState(() => _status = 'Failed to add student: $e');
    }
  }

  Future<void> _getStudentsExample() async {
    setState(() => _status = 'Fetching students...');
    try {
      List<StudentModel> students = await _databaseService.getAllStudents();
      setState(() {
        _students = students;
        _status = 'Fetched ${students.length} students';
      });
    } catch (e) {
      setState(() => _status = 'Failed to fetch students: $e');
    }
  }

  Future<void> _addFacultyExample() async {
    setState(() => _status = 'Adding faculty...');
    try {
      String facultyId = await _databaseService.createFaculty({
        'employeeId': 'EMP001',
        'name': 'Dr. Smith',
        'email': 'dr.smith@example.com',
        'phone': '+1234567892',
        'department': 'Mathematics',
        'designation': 'Senior Teacher',
        'dateOfBirth': DateTime(1980, 1, 1),
        'gender': 'Female',
        'address': '456 Oak St, City, State',
        'joiningDate': DateTime.now(),
        'subjects': ['Mathematics', 'Statistics'],
        'classes': ['10th', '11th', '12th'],
        'qualifications': {
          'degree': 'PhD in Mathematics',
          'university': 'University of Example',
          'year': 2010,
        },
      });
      setState(() => _status = 'Faculty added with ID: $facultyId');
    } catch (e) {
      setState(() => _status = 'Failed to add faculty: $e');
    }
  }

  Future<void> _getFacultyExample() async {
    setState(() => _status = 'Fetching faculty...');
    try {
      List<FacultyModel> faculty = await _databaseService.getAllFaculty();
      setState(() {
        _faculty = faculty;
        _status = 'Fetched ${faculty.length} faculty members';
      });
    } catch (e) {
      setState(() => _status = 'Failed to fetch faculty: $e');
    }
  }

  Future<void> _markAttendanceExample() async {
    setState(() => _status = 'Marking attendance...');
    try {
      await _databaseService.markAttendance(
        'studentId123',
        '2024-01-15',
        {
          'studentId': 'studentId123',
          'studentName': 'John Doe',
          'studentUSN': 'USN001',
          'className': '10th',
          'section': 'A',
          'subject': 'Mathematics',
          'facultyId': 'facultyId123',
          'facultyName': 'Dr. Smith',
          'date': DateTime.now(),
          'status': 'present',
          'markedBy': 'facultyId123',
        },
      );
      setState(() => _status = 'Attendance marked successfully!');
    } catch (e) {
      setState(() => _status = 'Failed to mark attendance: $e');
    }
  }

  // Cloudinary Examples (replaces Firebase Storage)
  Future<void> _uploadProfileImageExample() async {
    setState(() => _status = 'Uploading profile image...');
    try {
      // This would typically be triggered by user selecting an image
      setState(() => _status = 'Profile image upload example (select image first)');
    } catch (e) {
      setState(() => _status = 'Profile image upload failed: $e');
    }
  }

  Future<void> _uploadDocumentExample() async {
    setState(() => _status = 'Uploading document...');
    try {
      // This would typically be triggered by user selecting a document
      setState(() => _status = 'Document upload example (select document first)');
    } catch (e) {
      setState(() => _status = 'Document upload failed: $e');
    }
  }

  Future<void> _uploadAttendanceSheetExample() async {
    setState(() => _status = 'Uploading attendance sheet...');
    try {
      // This would typically be triggered by user selecting a sheet
      setState(() => _status = 'Attendance sheet upload example (select sheet first)');
    } catch (e) {
      setState(() => _status = 'Attendance sheet upload failed: $e');
    }
  }

  Future<void> _pickAndUploadImageExample() async {
    setState(() => _status = 'Picking and uploading image...');
    try {
      var result = await _cloudinaryService.pickAndUploadImage(
        folder: 'paramount/examples',
        tags: {'type': 'example', 'source': 'gallery'},
      );
      
      if (result != null) {
        setState(() => _status = 'Image uploaded successfully! URL: ${result['url']}');
      } else {
        setState(() => _status = 'No image selected');
      }
    } catch (e) {
      setState(() => _status = 'Image pick and upload failed: $e');
    }
  }

  Future<void> _captureAndUploadImageExample() async {
    setState(() => _status = 'Capturing and uploading image...');
    try {
      var result = await _cloudinaryService.captureAndUploadImage(
        folder: 'paramount/examples',
        tags: {'type': 'example', 'source': 'camera'},
      );
      
      if (result != null) {
        setState(() => _status = 'Image captured and uploaded! URL: ${result['url']}');
      } else {
        setState(() => _status = 'No image captured');
      }
    } catch (e) {
      setState(() => _status = 'Image capture and upload failed: $e');
    }
  }

  // Search Examples
  Future<void> _searchStudentsExample() async {
    setState(() => _status = 'Searching students...');
    try {
      List<StudentModel> results = await _databaseService.searchStudents('John');
      setState(() {
        _students = results;
        _status = 'Found ${results.length} students matching "John"';
      });
    } catch (e) {
      setState(() => _status = 'Student search failed: $e');
    }
  }

  Future<void> _searchFacultyExample() async {
    setState(() => _status = 'Searching faculty...');
    try {
      List<FacultyModel> results = await _databaseService.searchFaculty('Smith');
      setState(() {
        _faculty = results;
        _status = 'Found ${results.length} faculty matching "Smith"';
      });
    } catch (e) {
      setState(() => _status = 'Faculty search failed: $e');
    }
  }

  // Statistics Examples
  Future<void> _getAttendanceStatsExample() async {
    setState(() => _status = 'Getting attendance statistics...');
    try {
      Map<String, dynamic> stats = await _databaseService.getAttendanceStatistics(
        'studentId123',
        '2024-01-01',
        '2024-01-31',
      );
      setState(() => _status = 'Attendance: ${stats['attendancePercentage']}% present');
    } catch (e) {
      setState(() => _status = 'Failed to get attendance statistics: $e');
    }
  }
}

// Example of how to use the services in your existing pages
class ExampleIntegration {
  static final AuthService _authService = AuthService();
  static final DatabaseService _databaseService = DatabaseService();
  static final CloudinaryService _cloudinaryService = CloudinaryService(); // Updated

  // Example: Check if user is teacher and redirect accordingly
  static Future<void> handleUserLogin(BuildContext context) async {
    try {
      User? currentUser = _authService.currentUser;
      if (currentUser != null) {
        String? role = await _authService.getUserRole(currentUser.uid);
        
        if (role == 'teacher') {
          // Navigate to teacher home page
          Navigator.pushReplacementNamed(context, '/teacher-home');
        } else if (role == 'student') {
          // Navigate to student home page
          Navigator.pushReplacementNamed(context, '/student-home');
        } else {
          // Handle unknown role
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unknown user role')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Example: Add student with validation
  static Future<bool> addStudentWithValidation(Map<String, dynamic> studentData) async {
    try {
      // Validate data
      if (!_databaseService.validateStudentData(studentData)) {
        throw Exception('Invalid student data');
      }

      // Check if USN already exists
      StudentModel? existingStudent = await _databaseService.getStudentByUSN(studentData['usn']);
      if (existingStudent != null) {
        throw Exception('Student with this USN already exists');
      }

      // Create student
      String studentId = await _databaseService.createStudent(studentData);
      print('Student created with ID: $studentId');
      return true;
    } catch (e) {
      print('Failed to add student: $e');
      return false;
    }
  }

  // Example: Mark attendance for entire class
  static Future<bool> markClassAttendance(
    String className,
    String section,
    String subject,
    String facultyId,
    String facultyName,
    DateTime date,
    List<Map<String, dynamic>> attendanceRecords,
  ) async {
    try {
      // Prepare attendance data
      List<Map<String, dynamic>> preparedRecords = attendanceRecords.map((record) {
        return {
          ...record,
          'className': className,
          'section': section,
          'subject': subject,
          'facultyId': facultyId,
          'facultyName': facultyName,
          'date': date,
          'markedAt': DateTime.now(),
          'markedBy': facultyId,
        };
      }).toList();

      // Mark attendance in batch
      await _databaseService.batchMarkAttendance(preparedRecords);
      print('Class attendance marked successfully');
      return true;
    } catch (e) {
      print('Failed to mark class attendance: $e');
      return false;
    }
  }

  // Example: Upload and update profile image using Cloudinary
  static Future<bool> updateProfileImage(String userId, File imageFile) async {
    try {
      // Upload image to Cloudinary
      var result = await _cloudinaryService.uploadProfileImage(userId, imageFile);
      
      if (result != null && result['success'] == true) {
        // Update user profile with new image URL
        await _databaseService.updateUser(userId, {
          'profileImageUrl': result['url'],
          'profileImagePublicId': result['public_id'], // Store Cloudinary public ID
        });
        print('Profile image updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to update profile image: $e');
      return false;
    }
  }

  // Example: Upload attendance sheet using Cloudinary
  static Future<bool> uploadAttendanceSheet(
    String className,
    String date,
    File sheet,
    String facultyId,
  ) async {
    try {
      var result = await _cloudinaryService.uploadAttendanceSheet(
        className,
        date,
        sheet,
        facultyId: facultyId,
        tags: {
          'faculty_id': facultyId,
          'uploaded_at': DateTime.now().toIso8601String(),
        },
      );
      
      if (result != null && result['success'] == true) {
        // Store the Cloudinary URL in your database if needed
        print('Attendance sheet uploaded successfully: ${result['url']}');
        return true;
      }
      return false;
    } catch (e) {
      print('Failed to upload attendance sheet: $e');
      return false;
    }
  }

  // Example: Upload multiple documents
  static Future<List<Map<String, dynamic>>> uploadMultipleDocuments(
    String userId,
    List<File> documents,
    String documentType,
  ) async {
    try {
      List<Map<String, dynamic>> results = [];
      
      for (File document in documents) {
        try {
          var result = await _cloudinaryService.uploadDocument(
            userId,
            document,
            documentType,
            tags: {
              'uploaded_at': DateTime.now().toIso8601String(),
              'batch_upload': 'true',
            },
          );
          
          if (result != null && result['success'] == true) {
            results.add({
              'success': true,
              'document': document.path,
              'url': result['url'],
              'public_id': result['public_id'],
            });
          } else {
            results.add({
              'success': false,
              'document': document.path,
              'error': 'Upload failed',
            });
          }
        } catch (e) {
          results.add({
            'success': false,
            'document': document.path,
            'error': e.toString(),
          });
        }
      }
      
      return results;
    } catch (e) {
      print('Failed to upload multiple documents: $e');
      return [];
    }
  }
} 