import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class AddAcademicYearDialog extends StatelessWidget {
  final String branch;

  AddAcademicYearDialog({required this.branch});

  @override
  Widget build(BuildContext context) {
    TextEditingController academicYearController = TextEditingController();

    return AlertDialog(
      title: Text('Add Academic Year'),
      content: TextField(
        controller: academicYearController,
        decoration: InputDecoration(labelText: 'Academic Year'),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String academicYear = academicYearController.text.trim();

            if (academicYear.isNotEmpty) {
              final firestore = FirebaseFirestore.instance;
              final realtimeDatabase = FirebaseDatabase.instance.reference();

              try {
                // Add to Firestore
                await firestore
                    .collection('branches')
                    .doc(branch)
                    .collection('academicYears')
                    .doc(academicYear)
                    .set({});

                // Add to Realtime Database
                await realtimeDatabase
                    .child('branches/$branch/academicYears/$academicYear')
                    .set(true);

                Navigator.pop(context, academicYear);
              } catch (e) {
                print('Error adding academic year: $e');
              }
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}
