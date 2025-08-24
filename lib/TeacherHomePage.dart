import 'package:flutter/material.dart';

// Dummy data for a placeholder teacher
const String dummyTeacherName = "Anjali Mehta";
const String dummyTeacherEmail = "anjali.mehta@example.com";

// Dummy data for students and faculty
final List<String> dummyStudents = [
  "John Doe",
  "Jane Smith",
  "Aaryan Upadhyay"
];
final List<String> dummyFaculty = [
  "Dr. Sunil Upadhyay",
  "Dr. Anjali Mehta",
  "Prof. Rahul Sharma"
];

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Teacher Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
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
                dummyTeacherName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              accountEmail: const Text(dummyTeacherEmail),
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
              onTap: () => Navigator.of(context).pop(),
            ),
            ListTile(
              leading: const Icon(Icons.group, color: Colors.indigo),
              title: const Text("Students"),
              onTap: () {
                Navigator.of(context).pop();
                // Add your navigation logic here, e.g., to a new StudentsPage
              },
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Colors.indigo),
              title: const Text("Faculty"),
              onTap: () {
                Navigator.of(context).pop();
                // Add your navigation logic here, e.g., to a new FacultyPage
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                Navigator.of(context).pop();
                // Dummy logout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Logged out successfully!")),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              "Welcome, $dummyTeacherName!",
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Here's a quick overview of your dashboard.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),

            // Students Section
            _buildDashboardCard(
              title: "Students",
              icon: Icons.group,
              count: dummyStudents.length,
              list: dummyStudents,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 20),

            // Faculty Section
            _buildDashboardCard(
              title: "Faculty",
              icon: Icons.people,
              count: dummyFaculty.length,
              list: dummyFaculty,
              color: Colors.orange.shade700,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a reusable dashboard card
  Widget _buildDashboardCard({
    required String title,
    required IconData icon,
    required int count,
    required List<String> list,
    required Color color,
  }) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 40, color: color),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    "$title ($count)",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 30),
            ...list.take(3).map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Colors.grey.shade500),
                  const SizedBox(width: 10),
                  Text(
                    item,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            )).toList(),
            if (list.length > 3)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "and ${list.length - 3} more...",
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
