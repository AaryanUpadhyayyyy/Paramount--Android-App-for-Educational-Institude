// import 'dart:async';
import 'package:flutter/material.dart';
// Default Home Page, will be replaced by role-specific
import 'package:paramount/splashscreen.dart';
// Firebase imports removed

// Removed: import 'package:google_sign_in/google_sign_in.dart'; // Google Sign-In
// Import your generated firebase_options.dart
// import 'firebase_options.dart'; // Firebase options import removed

// New: TeacherHomePage and StudentHomePage imports
// import 'package:paramount/TeacherHomePage.dart'; // Nayi file banayenge
// import 'package:paramount/StudentHomePage.dart'; // Nayi file banayenge

void main() async {
  // main function ko async banaya
  WidgetsFlutterBinding.ensureInitialized(); // Flutter engine ko initialize karein
  // Firebase initialization removed
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paramount Classes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        hintColor: Colors.grey.shade600,
        fontFamily: 'Roboto',
      ),
      home: const splashscreen(), // Splash screen se start
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  var emailController =
      TextEditingController(); // Renamed for clarity: now strictly for email
  // bool _isButtonEnabled = false; // Unused after Firebase removal
  bool _isLoading = false; // For loading indicator

  // Phone Auth specific variables removed

  @override
  void initState() {
    super.initState();
    emailController.addListener(_updateButtonState); // Updated controller name
    passwordController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    emailController.dispose(); // Updated controller name
    passwordController.dispose();
    // Phone Auth specific controllers disposed
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // Button enabled only if email/password is entered
      // (No-op: Firebase login removed)
    });
  }

  // _handleLoginSuccess removed (Firebase logic)

  // _signInWithEmailPassword removed (Firebase logic)

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      body: Stack(
        children: [
          // Background Circle
          Positioned(
            top: -size.width * 0.2,
            left: -size.width * 0.4,
            child: Container(
              width: size.width * 1.2,
              height: size.width * 1.2,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: size.width * 1.5,
            left: size.width * 0.2,
            child: Container(
              width: size.width * 1.2,
              height: size.width * 1.2,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // 3D Character Image (Ensure assets/images/loginimage.png exists)
          Positioned(
            top: 0,
            left: (size.width - 300) / 2,
            child: SizedBox(
              width: 300,
              height: 300,
              child: Image.asset(
                "assets/images/loginimage.png",
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 150, color: Colors.grey),
              ),
            ),
          ),

          // Login Form
          Positioned(
            top: size.height * 0.35,
            left: 20,
            right: 20,
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Sign In",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Divider(
                      color: Colors.blue,
                      thickness: 3,
                      endIndent: 200,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        prefixIcon: const Icon(Icons.email, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        prefixIcon: const Icon(Icons.lock, color: Colors.blue),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: null, // Login disabled (Firebase removed)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("LOGIN", style: TextStyle(fontSize: 18)),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
