import 'dart:async';
import 'package:flutter/material.dart';
import 'package:paramount/main.dart'; // LoginPage import karne ke liye

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  final String _fullText = "Upadhyay Paramount Classes";
  String _displayedText = "";
  int _currentIndex = 0;
  Timer? _animationTimer;

  @override
  void initState() {
    super.initState();
    _startTypewriterAnimation();

    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()), // 'title' parameter hata diya
      );
    });
  }

  void _startTypewriterAnimation() {
    _animationTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (_currentIndex < _fullText.length) {
        setState(() {
          _displayedText += _fullText[_currentIndex];
          _currentIndex++;
        });
      } else {
        _animationTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
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
            _displayedText,
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
