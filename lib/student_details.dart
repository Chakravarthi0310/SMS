import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentDetails extends StatelessWidget {
  final String branch;
  final String academicYear;
  final String section;
  final String studentId;

  const StudentDetails({
    required this.branch,
    required this.academicYear,
    required this.section,
    required this.studentId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('branches')
              .doc(branch)
              .collection('academicYears')
              .doc(academicYear)
              .collection('sections')
              .doc(section)
              .collection('students')
              .doc(studentId)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Access the student data
            Map<String, dynamic> studentData =
                snapshot.data!.data() as Map<String, dynamic>;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Name: ${studentData['name'] ?? 'N/A'}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Roll Number: ${studentData['rollNumber'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Email: ${studentData['email'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("Phone: ${studentData['phone'] ?? 'N/A'}",
                    style: TextStyle(fontSize: 16)),
                // Add other fields as needed
              ],
            );
          },
        ),
      ),
    );
  }
}
