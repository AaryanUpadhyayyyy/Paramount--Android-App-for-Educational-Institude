import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ke liye
import 'package:firebase_auth/firebase_auth.dart'; // Current user ID ke liye
import 'package:intl/intl.dart'; // Date formatting ke liye

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  DateTime _selectedDate = DateTime.now(); // Default selected date
  List<Map<String, dynamic>> _students = []; // Students ki list
  Map<String, String> _attendanceStatus = {}; // StudentId -> Status (Present/Absent/Late)
  final Map<String, Map<String, dynamic>> _studentDetailsMap = {}; // StudentId -> {name, usn} for easy lookup

  bool _isLoading = false; // Loading indicator for data operations

  @override
  void initState() {
    super.initState();
    _fetchStudentsAndAttendance(); // Page load hote hi students aur attendance fetch karein
  }

  // Date select karne ke liye function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023, 1), // Attendance tracking start date
      lastDate: DateTime.now().add(const Duration(days: 30)), // Future dates tak select kar sakte hain
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.indigo.shade700, // Header background color
              onPrimary: Colors.white, // Header text color
              onSurface: Colors.black, // Body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.indigo.shade700, // Button text color
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
        _attendanceStatus.clear(); // Date change hone par attendance status reset karein
      });
      await _fetchStudentsAndAttendance(); // Nayi date ke liye students aur attendance fetch karein
    }
  }

  // Firestore se students ki list aur us date ki attendance fetch karein
  Future<void> _fetchStudentsAndAttendance() async {
    setState(() { _isLoading = true; });
    try {
      // 1. Fetch all students
      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'student')
          .get();

      _students = studentSnapshot.docs.map((doc) {
        _studentDetailsMap[doc.id] = {'name': doc['name'], 'usn': doc['usn']};
        return {
          'id': doc.id, // Firebase Auth UID
          'name': doc['name'],
          'usn': doc['usn'],
        };
      }).toList();

      // 2. Fetch existing attendance for the selected date from the centralized collection
      String dateId = DateFormat('yyyy-MM-dd').format(_selectedDate); // Format date as YYYY-MM-DD

      DocumentSnapshot attendanceDoc = await FirebaseFirestore.instance
          .collection('attendances') // Centralized collection
          .doc(dateId)
          .get();

      Map<String, String> currentAttendance = {};
      if (attendanceDoc.exists && attendanceDoc.data() != null) {
        List<dynamic> records = (attendanceDoc.data() as Map<String, dynamic>)['records'] ?? [];
        for (var record in records) {
          currentAttendance[record['studentId']] = record['status'];
        }
      }

      // Initialize attendance status for all students (default to Absent if not found)
      for (var student in _students) {
        if (!currentAttendance.containsKey(student['id'])) {
          currentAttendance[student['id']] = 'Absent';
        }
      }

      setState(() {
        _attendanceStatus = currentAttendance;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
      debugPrint('Error fetching data: $e');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // Attendance status update karein
  void _updateAttendanceStatus(String studentId, String status) {
    setState(() {
      _attendanceStatus[studentId] = status;
    });
  }

  // Attendance data Firestore mein save karein
  Future<void> _saveAttendance() async {
    setState(() { _isLoading = true; });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please login as a teacher to mark attendance.')),
        );
        return;
      }
      String teacherId = user.uid;

      // Format date as YYYY-MM-DD for document ID
      String dateId = DateFormat('yyyy-MM-dd').format(_selectedDate);

      // Prepare records for the centralized document
      List<Map<String, dynamic>> recordsToSave = [];
      for (var student in _students) {
        String studentId = student['id'];
        String status = _attendanceStatus[studentId] ?? 'Absent';
        Map<String, dynamic> studentDetails = _studentDetailsMap[studentId] ?? {}; // Get name and usn

        recordsToSave.add({
          'studentId': studentId,
          'status': status,
          'name': studentDetails['name'], // Add student name
          'usn': studentDetails['usn'],   // Add student USN
        });
      }

      // Save to centralized attendance collection
      await FirebaseFirestore.instance
          .collection('attendances') // Centralized collection
          .doc(dateId)
          .set({
        'date': Timestamp.fromDate(_selectedDate), // Store as Timestamp
        'teacherId': teacherId,
        'records': recordsToSave,
        'timestampMarked': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true)); // Use merge to update existing fields without overwriting others

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Attendance saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving attendance: $e')),
      );
      debugPrint('Error saving attendance: $e');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mark Attendance",
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Loading indicator
          : Column(
        children: [
          // Date Picker Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Selected Date:",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd MMM yyyy').format(_selectedDate),
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_today, color: Colors.white),
                      label: const Text("Change Date", style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(), // Separator

          // Student List for Attendance Marking
          Expanded(
            child: _students.isEmpty
                ? const Center(
              child: Text(
                "No students found. Please add students first.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _students.length,
              itemBuilder: (context, index) {
                final student = _students[index];
                final studentId = student['id'];
                final currentStatus = _attendanceStatus[studentId] ?? 'Absent';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${student['name']} (${student['usn']})",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildAttendanceOption(
                              'Present',
                              currentStatus,
                                  () => _updateAttendanceStatus(studentId, 'Present'),
                              Colors.green,
                            ),
                            _buildAttendanceOption(
                              'Absent',
                              currentStatus,
                                  () => _updateAttendanceStatus(studentId, 'Absent'),
                              Colors.red,
                            ),
                            _buildAttendanceOption(
                              'Late',
                              currentStatus,
                                  () => _updateAttendanceStatus(studentId, 'Late'),
                              Colors.orange,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Save Attendance Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _isLoading ? null : _saveAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                "Save Attendance",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method for attendance options (Present/Absent/Late)
  Widget _buildAttendanceOption(String option, String currentStatus, VoidCallback onPressed, Color color) {
    bool isSelected = currentStatus == option;
    return ChoiceChip(
      label: Text(option),
      selected: isSelected,
      selectedColor: color.withOpacity(0.2), // Light color when selected
      onSelected: (selected) {
        if (selected) {
          onPressed();
        }
      },
      labelStyle: TextStyle(
        color: isSelected ? color : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(color: isSelected ? color : Colors.grey.shade400),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}
