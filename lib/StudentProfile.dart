// StudentProfile.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentProfile extends StatefulWidget {
  final User? user;
  final String selectedBranch;
  final String selectedAcademicYear;
  final String selectedSection;

  const StudentProfile({
    Key? key,
    required this.user,
    required this.selectedBranch,
    required this.selectedAcademicYear,
    required this.selectedSection,
  }) : super(key: key);

  @override
  _StudentProfileState createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  late Stream<DocumentSnapshot> _stream;
  Map<String, dynamic>? _studentData;

  @override
  void initState() {
    super.initState();
    // Set up the stream to listen for changes in the Firestore document
    _stream = FirebaseFirestore.instance
        .collection('branches')
        .doc(widget.selectedBranch)
        .collection('academicYears')
        .doc(widget.selectedAcademicYear)
        .collection('sections')
        .doc(widget.selectedSection)
        .collection('students')
        .doc(widget.user?.uid)
        .snapshots();

    // Fetch the initial data
    fetchData();
  }

  void fetchData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('branches')
          .doc(widget.selectedBranch)
          .collection('academicYears')
          .doc(widget.selectedAcademicYear)
          .collection('sections')
          .doc(widget.selectedSection)
          .collection('students')
          .doc(widget.user?.uid)
          .get();

      if (snapshot.exists) {
        setState(() {
          _studentData = snapshot.data() as Map<String, dynamic>;
        });
      } else {
        // Handle the case when the document doesn't exist
        print('Student data not found');
      }
    } catch (e) {
      // Handle any errors that might occur during the fetch
      print('Error fetching student data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('Student data not found');
            } else {
              // Retrieve data from the snapshot
              var data = _studentData ?? {};

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Roll Number: ${data['rollNumber'] ?? 'N/A'}"),
                  Text("Name: ${data['name'] ?? 'N/A'}"),
                  Text("Email: ${data['email'] ?? 'N/A'}"),
                  Text("Phone: ${data['phone'] ?? 'N/A'}"),
                  // Add more details as needed
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
