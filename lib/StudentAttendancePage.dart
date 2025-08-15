import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore ke liye
import 'package:firebase_auth/firebase_auth.dart'; // Current user ID ke liye
import 'package:intl/intl.dart'; // Date formatting ke liye

class StudentAttendancePage extends StatefulWidget {
  const StudentAttendancePage({super.key});

  @override
  State<StudentAttendancePage> createState() => _StudentAttendancePageState();
}

class _StudentAttendancePageState extends State<StudentAttendancePage> {
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoading = false;
  String? _currentUserId;

  // Summary counts
  int _totalPresent = 0;
  int _totalAbsent = 0;
  int _totalLate = 0;
  int _totalMarkedDays = 0;
  double _attendancePercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _getCurrentUserAndFetchAttendance();
  }

  Future<void> _getCurrentUserAndFetchAttendance() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in. Please log in.')),
      );
      return;
    }
    setState(() {
      _currentUserId = user.uid;
    });
    await _fetchStudentAttendance();
  }

  Future<void> _fetchStudentAttendance() async {
    if (_currentUserId == null) return;

    setState(() { _isLoading = true; });
    try {
      // Fetch ALL attendance documents from the centralized 'attendances' collection
      // For better performance, consider fetching only a relevant date range (e.g., last 6 months)
      // Or, ideally, use Cloud Functions for denormalization (as discussed previously)
      QuerySnapshot allAttendanceDocs = await FirebaseFirestore.instance
          .collection('attendances')
          .orderBy('date', descending: true) // Latest attendance pehle dikhegi
          .get();

      List<Map<String, dynamic>> studentSpecificRecords = [];
      int tempTotalPresent = 0;
      int tempTotalAbsent = 0;
      int tempTotalLate = 0;
      int tempTotalMarkedDays = 0;

      for (var doc in allAttendanceDocs.docs) {
        List<dynamic> records = (doc.data() as Map<String, dynamic>)['records'] ?? [];
        DateTime attendanceDate = (doc['date'] as Timestamp).toDate();

        // Client-side filtering: Find the current student's record for this day
        for (var record in records) {
          if (record['studentId'] == _currentUserId) {
            studentSpecificRecords.add({
              'date': attendanceDate,
              'status': record['status'],
            });
            // Update summary counts
            String status = record['status'];
            if (status == 'Present') {
              tempTotalPresent++;
            } else if (status == 'Absent') {
              tempTotalAbsent++;
            } else if (status == 'Late') {
              tempTotalLate++;
            }
            tempTotalMarkedDays++;
            break; // Found student's record for this day, move to next attendance document
          }
        }
      }

      setState(() {
        _attendanceRecords = studentSpecificRecords;
        _totalPresent = tempTotalPresent;
        _totalAbsent = tempTotalAbsent;
        _totalLate = tempTotalLate;
        _totalMarkedDays = tempTotalMarkedDays;
        if (_totalMarkedDays > 0) {
          _attendancePercentage = (_totalPresent + _totalLate) / _totalMarkedDays * 100;
        } else {
          _attendancePercentage = 0.0;
        }
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching attendance: $e')),
      );
      debugPrint('Error fetching attendance: $e');
    } finally {
      setState(() { _isLoading = false; });
    }
  }

  // _calculateAttendanceSummary() method ab _fetchStudentAttendance mein hi integrated hai


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Attendance",
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
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Attendance Summary
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSummaryRow("Total Days Marked:", _totalMarkedDays.toString()),
                    _buildSummaryRow("Present:", _totalPresent.toString(), color: Colors.green),
                    _buildSummaryRow("Absent:", _totalAbsent.toString(), color: Colors.red),
                    _buildSummaryRow("Late:", _totalLate.toString(), color: Colors.orange),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      "Attendance Percentage:",
                      "${_attendancePercentage.toStringAsFixed(2)}%",
                      isPercentage: true,
                      color: _attendancePercentage >= 75 ? Colors.green.shade700 : Colors.red.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Divider(),

          // Attendance History List
          Expanded(
            child: _attendanceRecords.isEmpty
                ? const Center(
              child: Text(
                "No attendance records found yet.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : ListView.builder(
              itemCount: _attendanceRecords.length,
              itemBuilder: (context, index) {
                final record = _attendanceRecords[index];
                final date = DateFormat('dd MMM yyyy').format(record['date']);
                final status = record['status'];
                Color statusColor;
                IconData statusIcon;

                switch (status) {
                  case 'Present':
                    statusColor = Colors.green.shade700;
                    statusIcon = Icons.check_circle;
                    break;
                  case 'Absent':
                    statusColor = Colors.red.shade700;
                    statusIcon = Icons.cancel;
                    break;
                  case 'Late':
                    statusColor = Colors.orange.shade700;
                    statusIcon = Icons.access_time;
                    break;
                  default:
                    statusColor = Colors.grey;
                    statusIcon = Icons.help_outline;
                }

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  child: ListTile(
                    leading: Icon(statusIcon, color: statusColor),
                    title: Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
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

  Widget _buildSummaryRow(String label, String value, {Color? color, bool isPercentage = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isPercentage ? 20 : 16,
              fontWeight: isPercentage ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
