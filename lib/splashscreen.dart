import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paramount/main.dart'; // LoginPage import karne ke liye


class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  final String _fullText = "Upadhyay Paramount Classes"; // Poora text jo type hoga
  String _displayedText = ""; // Jo text abhi display ho raha hai
  int _currentIndex = 0; // Current character ka index
  Timer? _animationTimer; // Animation ke liye timer

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation(); // Typewriter animation start karein

    // 5 seconds baad LoginPage par navigate karein
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login')),
      );
    });
  }

  // Typewriter animation ko handle karne ke liye method
  void _startTypewriterAnimation() {
    // Har 150ms mein ek character add karein, jisse animation smooth ho
    _animationTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        _animationTimer?.cancel(); // Jab poora text type ho jaye, timer cancel kar dein
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel(); // Screen dispose hone par timer ko cancel karna zaruri hai
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blue,
        child: Center(
          child: Text(
            _displayedText, // Ab yahan _displayedText use karenge
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontFamily: 'Oswald-VariableFont_wght',
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
