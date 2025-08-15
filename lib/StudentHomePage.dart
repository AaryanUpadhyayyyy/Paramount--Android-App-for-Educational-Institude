import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart'; // Firebase removed
import 'package:paramount/main.dart'; // For LoginPage navigation
import 'package:paramount/HomePage.dart'; // Your existing HomePage as student's main dashboard content

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Student Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Firebase logout removed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(title: 'Login'),
                ), // Back to login
              );
            },
          ),
        ],
      ),
      body:
          const HomePage(), // Student ke liye existing HomePage ko use kar sakte hain as dashboard
    );
  }
}
