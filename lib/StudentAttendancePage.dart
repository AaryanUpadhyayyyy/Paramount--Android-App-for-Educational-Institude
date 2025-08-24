import 'package:flutter/material.dart';

class StudentHomePage extends StatelessWidget {
  // Constructor ab dummy data se student ka naam aur USN leta hai
  final String usn;
  final String name;

  const StudentHomePage({
    super.key,
    this.usn = "1BM19CS01", // Dummy USN
    this.name = "John Doe", // Dummy Name
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home Page'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dummy Profile Card
            Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.indigo,
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Welcome, $name!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'USN: $usn',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const Divider(height: 30, thickness: 1),
                    _buildInfoRow(Icons.email, 'johndoe@example.com'),
                    _buildInfoRow(Icons.phone, '9876543210'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Navigation Grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildGridItem(context, 'Attendance', Icons.event_available, () {
                  Navigator.pushNamed(context, '/student_attendance');
                }),
                _buildGridItem(context, 'Announcements', Icons.notifications, () {
                  // Dummy action
                }),
                _buildGridItem(context, 'Assignments', Icons.assignment, () {
                  // Dummy action
                }),
                _buildGridItem(context, 'Result', Icons.score, () {
                  // Dummy action
                }),
                _buildGridItem(context, 'Fee Payment', Icons.payment, () {
                  // Dummy action
                }),
                _buildGridItem(context, 'Calendar', Icons.calendar_today, () {
                  // Dummy action
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for profile info rows
  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: Colors.indigo),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
          ),
        ],
      ),
    );
  }

  // Helper method for grid items
  Widget _buildGridItem(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.indigo),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
