import 'package:flutter/material.dart';

// Dummy data for a placeholder user
const String dummyUserName = "Aaryan Upadhyay";
const String dummyUserEmail = "aaryan.upadhyay@example.com";
const String dummyUserRole = "Teacher";

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // A dummy function that just shows a message
  void _dummySignOut(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Signed out successfully (dummy).")),
    );
    // Dummy navigation to login page
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        title: const Text(
          "Paramount",
          style: TextStyle(
            fontFamily: 'Oswald-VariableFont_wght',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 4.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo.shade700,
              ),
              accountName: const Text(
                dummyUserName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: const Text(dummyUserEmail),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Colors.indigo,
                  size: 50,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: const Text("Home"),
              onTap: () {
                Navigator.of(context).pop();
                // Already on Home Page
              },
            ),
            ListTile(
              leading: const Icon(Icons.school, color: Colors.indigo),
              title: const Text("Students"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/students');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.indigo),
              title: const Text("Faculty"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/faculty');
              },
            ),
            ListTile(
              leading: const Icon(Icons.book, color: Colors.indigo),
              title: const Text("Courses"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/courses');
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time, color: Colors.indigo),
              title: const Text("Attendance"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/attendance');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text("Settings"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/settings');
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.indigo),
              title: const Text("About Us"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/about');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                _dummySignOut(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.school,
              size: 100,
              color: Colors.indigo,
            ),
            const SizedBox(height: 20),
            Text(
              "Welcome, $dummyUserName!",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Role: $dummyUserRole",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                _dummySignOut(context);
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
