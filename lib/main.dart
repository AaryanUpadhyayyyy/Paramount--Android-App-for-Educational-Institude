import 'package:flutter/material.dart';
import 'package:paramount/Attendance.dart';
import 'package:paramount/Faculty.dart';
import 'package:paramount/HomePage.dart';
import 'package:paramount/StudentAttendancePage.dart';
import 'package:paramount/StudentHomePage.dart';
import 'package:paramount/TeacherHomePage.dart';
import 'package:paramount/add_student_page.dart';
import 'package:paramount/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paramount App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Oswald-VariableFont_wght', // Default font set
      ),
      // Initial route SplashScreen hoga
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(), // Login page
        '/teacher_home': (context) => const TeacherHomePage(), // Teacher's home page
        '/student_home': (context) => const StudentHomePage(), // Student's home page (dummy)
        '/attendance': (context) => const AttendancePage(), // Attendance page
        '/faculty': (context) => const Faculty(), // Faculty page
        '/add_student': (context) => const AddStudentPage(), // Add student page
        '/student_attendance': (context) => const StudentAttendancePage(), // Student's attendance page
      },
    );
  }
}

// Login Page Widget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  // Frontend-only login logic
  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      // Teacher login logic
      if (email == "sunil" && password == "Au20052005") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Teacher Login Successful! Redirecting...")),
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/teacher_home');
      }
      // Student login logic (any other valid credentials)
      else if (email.isNotEmpty && password.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Student Login Successful! Redirecting...")),
        );
        if (!mounted) return;
        // StudentHomePage ko dummy USN aur name ke saath navigate karein
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const StudentHomePage(
              usn: "DUMMY_USN", // Aap yahan real USN pass kar sakte hain agar available ho
              name: "Dummy Student", // Aap yahan real name pass kar sakte hain
            ),
          ),
        );
      }
      // Invalid credentials
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid Credentials. Please try again.")),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Screen size ke hisaab se responsive UI
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children:
