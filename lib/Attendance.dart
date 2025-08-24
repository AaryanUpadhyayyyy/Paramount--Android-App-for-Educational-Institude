import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Dummy data for frontend display
  final List<String> subjects = ['Math', 'Physics', 'Chemistry'];
  final List<String> studentNames = ['Rohit Sharma', 'Virat Kohli', 'MS Dhoni'];
  final List<String> rollNumbers = ['01', '02', '03'];

  // Dummy variables to simulate state
  String? _selectedSubject;
  String? _selectedSemester;
  String? _selectedCourse;
  String? _selectedRollNumber;

  @override
  void initState() {
    super.initState();
    // No backend initialization needed
  }

  // This function will now use dummy data
  Future<void> _fetchAndDisplayAttendance() async {
    // In a real app, this would fetch data from a database
    // For now, we are just showing a loading indicator and a message.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fetching attendance data...')),
    );

    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance data loaded!')),
    );
  }

  // This function will also use dummy data and not upload anything
  Future<void> _markAttendance() async {
    if (_selectedRollNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a student.')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Marking attendance for Roll No: $_selectedRollNumber')),
    );

    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 2));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Attendance marked successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Subject Selection
            const Text(
              'Select Subject',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Subject',
              ),
              items: subjects.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedSubject = newValue;
                });
              },
            ),

            const SizedBox(height: 20),
            
            // Student and Roll Number Selection (Combined for simplicity)
            const Text(
              'Mark Attendance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedRollNumber,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Student (Roll No)',
              ),
              items: rollNumbers.map((String rollNo) {
                return DropdownMenuItem<String>(
                  value: rollNo,
                  child: Text('Roll No: $rollNo'),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRollNumber = newValue;
                });
              },
            ),

            const SizedBox(height: 20),

            // Buttons
            ElevatedButton.icon(
              onPressed: _markAttendance,
              icon: const Icon(Icons.check),
              label: const Text('Mark Present'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _fetchAndDisplayAttendance,
              icon: const Icon(Icons.download),
              label: const Text('View Attendance History'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
