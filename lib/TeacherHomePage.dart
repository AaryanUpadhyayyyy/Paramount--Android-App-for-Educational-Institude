import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:paramount/main.dart';
import 'package:paramount/add_student_page.dart';
import 'package:paramount/services/cloudinary_service.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  bool _isUploading = false;
  String? _lastUploadedUrl;

  Future<void> _uploadProfileImage() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not signed in')),
        );
        return;
      }

      setState(() => _isUploading = true);

      final cloudinary = CloudinaryService();
      final result = await cloudinary.pickAndUploadImage(
        folder: 'paramount/profile_images/${user.uid}',
        tags: {'type': 'profile_image', 'user_id': user.uid},
      );

      if (!mounted) return;

      if (result != null && (result['success'] == true || result['url'] != null)) {
        _lastUploadedUrl = result['url'] as String?;
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'profileImageUrl': result['url'],
          'profileImagePublicId': result['public_id'],
          'updatedAt': FieldValue.serverTimestamp(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated')),
        );
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No image selected')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Teacher Dashboard",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade700,
        actions: [
          IconButton(
            icon: _isUploading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.photo_camera, color: Colors.white),
            tooltip: 'Upload profile image',
            onPressed: _isUploading ? null : _uploadProfileImage,
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(title: 'Login'),
                ),
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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 12),
            if (_lastUploadedUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: CircleAvatar(
                  radius: 36,
                  backgroundImage: NetworkImage(_lastUploadedUrl!),
                ),
              ),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadProfileImage,
              child: Text(_isUploading ? 'Uploading...' : 'Upload Profile Image'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddStudentPage(),
                  ),
                );
              },
              child: const Text("Add New Student"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Mark Attendance feature coming soon!'),
                  ),
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
