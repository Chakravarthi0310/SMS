import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'student_details.dart';

class Students extends StatelessWidget {
  final String branch;
  final String academicYear;
  final String section;

  const Students({
    required this.branch,
    required this.academicYear,
    required this.section,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students - $section"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('branches')
              .doc(branch)
              .collection('academicYears')
              .doc(academicYear)
              .collection('sections')
              .doc(section)
              .collection('students')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            List<String> studentIds =
                snapshot.data!.docs.map((doc) => doc.id).toList();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (String studentId in studentIds)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetails(
                            branch: branch,
                            academicYear: academicYear,
                            section: section,
                            studentId: studentId,
                          ),
                        ),
                      );
                    },
                    child: Text("Student $studentId"),
                  ),
                SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
