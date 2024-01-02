import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AddStudentDialog extends StatefulWidget {
  final DatabaseReference studentsReference;
  final String section;

  AddStudentDialog({required this.studentsReference, required this.section});

  @override
  _AddStudentDialogState createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  TextEditingController studentNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Student"),
      content: TextField(
        controller: studentNameController,
        decoration: InputDecoration(labelText: 'Student Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            addNewStudent();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  void addNewStudent() {
    String studentName = studentNameController.text.trim();
    if (studentName.isNotEmpty) {
      widget.studentsReference.child(studentName).set({'name': studentName});
      Navigator.of(context).pop(studentName);
    }
  }
}
