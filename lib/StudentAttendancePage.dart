import 'package:flutter/material.dart';

class StudentAttendancePage extends StatelessWidget {
  const StudentAttendancePage({super.key});

  // Dummy attendance data for UI
  final List<Map<String, dynamic>> dummyAttendance = const [
    {
      'date': '01 Jan 2024',
      'subject': 'Mathematics',
      'status': 'Present',
    },
    {
      'date': '02 Jan 2024',
      'subject': 'Physics',
      'status': 'Absent',
    },
    {
      'date': '03 Jan 2024',
      'subject': 'Chemistry',
      'status': 'Present',
    },
    {
      'date': '04 Jan 2024',
      'subject': 'Mathematics',
      'status': 'Late',
    },
    {
      'date': '05 Jan 2024',
      'subject': 'Physics',
      'status': 'Present',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Attendance',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Oswald-VariableFont_wght',
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.indigo.shade700,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: Column(
        children: [
          // Header showing total attendance
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatCard(
                      'Present',
                      3,
                      Colors.green.shade700,
                    ),
                    _buildStatCard(
                      'Absent',
                      1,
                      Colors.red.shade700,
                    ),
                    _buildStatCard(
                      'Late',
                      1,
                      Colors.orange.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),
          // Attendance History List
          Expanded(
            child: ListView.builder(
              itemCount: dummyAttendance.length,
              itemBuilder: (context, index) {
                final record = dummyAttendance[index];
                final status = record['status'] as String;
                Color statusColor = Colors.grey;
                IconData statusIcon = Icons.help;

                // Set color and icon based on status
                switch (status) {
                  case 'Present':
                    statusColor = Colors.green;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'Absent':
                    statusColor = Colors.red;
                    statusIcon = Icons.cancel;
                    break;
                  case 'Late':
                    statusColor = Colors.orange;
                    statusIcon = Icons.access_time_filled;
                    break;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: statusColor,
                      child: Icon(statusIcon, color: Colors.white),
                    ),
                    title: Text(
                      record['subject'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Date: ${record['date']}'),
                    trailing: Chip(
                      label: Text(status),
                      backgroundColor: statusColor.withOpacity(0.1),
                      labelStyle: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, int count, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
