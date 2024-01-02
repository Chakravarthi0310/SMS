import 'package:flutter/material.dart';
import 'Sections.dart';
import 'AddAcademicYearDialog.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AcademicYears extends StatefulWidget {
  final String branch;

  const AcademicYears({required this.branch});

  @override
  _AcademicYearsState createState() => _AcademicYearsState();
}

class _AcademicYearsState extends State<AcademicYears> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> academicYears = [];

  @override
  void initState() {
    super.initState();
    fetchAcademicYears();
  }

  void fetchAcademicYears() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('branches')
          .doc(widget.branch)
          .collection('academicYears')
          .get();

      setState(() {
        academicYears = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching academic years: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Academic Years - ${widget.branch}"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddAcademicYearDialog(branch: widget.branch);
                },
              ).then((value) {
                // Update the UI when a new academic year is added
                if (value != null && value is String) {
                  fetchAcademicYears();
                }
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var academicYear in academicYears)
              ElevatedButton(
                onPressed: () {
                  // Create a CollectionReference for the 'sections' subcollection
                  CollectionReference sectionsReference = firestore
                      .collection('branches')
                      .doc(widget.branch)
                      .collection('academicYears')
                      .doc(academicYear)
                      .collection('sections');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Sections(
                        branch: widget.branch,
                        academicYear: academicYear,
                        sectionsReference: sectionsReference,
                      ),
                    ),
                  );
                },
                child: Text(academicYear),
              ),
          ],
        ),
      ),
    );
  }
}
