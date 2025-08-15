import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore removed
// import 'package:firebase_auth/firebase_auth.dart'; // Firebase removed
// import 'package:intl/intl.dart'; // Date formatting removed

class StudentAttendancePage extends StatelessWidget {
  const StudentAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Attendance')),
      body: const Center(
        child: Text(
          'Attendance data is not available. Firebase has been removed.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
