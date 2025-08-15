import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // For logout
import 'package:paramount/main.dart'; // For LoginPage navigation
import 'package:paramount/add_student_page.dart'; // AddStudentPage import

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Teacher Dashboard", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut(); // Logout user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login')), // Back to login
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome, Teacher!",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to Add Student Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddStudentPage()),
                );
              },
              child: const Text("Add New Student"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Navigate to Mark Attendance Page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mark Attendance feature coming soon!')),
                );
              },
              child: const Text("Mark Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
