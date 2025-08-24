import 'package:flutter/material.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  // Dummy data for students, each with an initial attendance status
  final List<Map<String, dynamic>> _students = [
    {'id': 'STD001', 'name': 'Alia Bhatt', 'status': 'Present'},
    {'id': 'STD002', 'name': 'Ranbir Kapoor', 'status': 'Absent'},
    {'id': 'STD003', 'name': 'Deepika Padukone', 'status': 'Present'},
    {'id': 'STD004', 'name': 'Ranveer Singh', 'status': 'Late'},
    {'id': 'STD005', 'name': 'Katrina Kaif', 'status': 'Present'},
    {'id': 'STD006', 'name': 'Vicky Kaushal', 'status': 'Absent'},
    {'id': 'STD007', 'name': 'Shah Rukh Khan', 'status': 'Present'},
    {'id': 'STD008', 'name': 'Salman Khan', 'status': 'Late'},
  ];

  String _selectedCourse = 'CS301 - Data Structures';
  final List<String> _courses = [
    'CS301 - Data Structures',
    'CS302 - Algorithms',
    'CS401 - Operating Systems',
    'CS402 - Database Management',
  ];

  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Attendance'),
      ),
      body: Column(
        children: [
          // Course and Date selection
          _buildCourseAndDateSelector(context),
          const Divider(height: 1, thickness: 1),
          // Student list for attendance marking
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                return _buildStudentAttendanceCard(context, student, index);
              },
            ),
          ),
          // Submit button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                _submitAttendance(context);
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Submit Attendance'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Course and Date selector UI
  Widget _buildCourseAndDateSelector(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Course Dropdown
          DropdownButtonFormField<String>(
            value: _selectedCourse,
            decoration: const InputDecoration(
              labelText: 'Select Course',
              prefixIcon: Icon(Icons.book),
            ),
            items: _courses.map((String course) {
              return DropdownMenuItem<String>(
                value: course,
                child: Text(course, style: const TextStyle(fontFamily: 'Oswald')),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCourse = newValue;
                });
              }
            },
          ),
          const SizedBox(height: 15),
          // Date Picker
          InkWell(
            onTap: () => _selectDate(context),
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Select Date',
                prefixIcon: Icon(Icons.calendar_month),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_selectedDate.toLocal()}'.split(' ')[0], // Date format
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'Oswald'),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Date picker function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).primaryColor, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Individual student attendance card
  Widget _buildStudentAttendanceCard(BuildContext context, Map<String, dynamic> student, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Text(
                student['name'][0], // Student ke naam ka pehla letter
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: 'Oswald',
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student['name'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900,
                      fontFamily: 'Oswald',
                    ),
                  ),
                  Text(
                    'ID: ${student['id']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontFamily: 'Oswald'),
                  ),
                ],
              ),
            ),
            // Radio buttons for attendance status
            DropdownButton<String>(
              value: _students[index]['status'],
              items: <String>['Present', 'Absent', 'Late'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle(fontFamily: 'Oswald')),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _students[index]['status'] = newValue;
                  });
                }
              },
              underline: Container(), // Remove default underline
              icon: Icon(Icons.arrow_drop_down, color: Colors.deepPurple.shade700),
            ),
          ],
        ),
      ),
    );
  }

  // Attendance submit logic
  void _submitAttendance(BuildContext context) {
    List<Map<String, dynamic>> finalAttendance = [];
    for (var student in _students) {
      finalAttendance.add({
        'studentId': student['id'],
        'studentName': student['name'],
        'status': student['status'],
        'course': _selectedCourse,
        'date': '${_selectedDate.toLocal()}'.split(' ')[0],
      });
    }
    // Yahan par aap finalAttendance list ko backend mein save kar sakte hain
    // For now, hum bas ek confirmation message dikhayenge
    _showMessage(
      context,
      'Attendance for $_selectedCourse on ${_selectedDate.toLocal().toString().split(' ')[0]} submitted successfully!',
    );
    debugPrint('Submitted Attendance: $finalAttendance');
  }

  // Generic message dialog
  void _showMessage(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Information', style: TextStyle(fontFamily: 'Oswald')),
          content: Text(message, style: const TextStyle(fontFamily: 'Oswald')),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Theme.of(dialogContext).primaryColor, fontFamily: 'Oswald')),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
