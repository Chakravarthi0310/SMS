import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSectionDialog extends StatefulWidget {
  final CollectionReference sectionsReference;

  AddSectionDialog({required this.sectionsReference});

  @override
  _AddSectionDialogState createState() => _AddSectionDialogState();
}

class _AddSectionDialogState extends State<AddSectionDialog> {
  TextEditingController sectionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add Section"),
      content: TextField(
        controller: sectionController,
        decoration: InputDecoration(labelText: 'Section'),
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
            addNewSection();
          },
          child: Text('Add'),
        ),
      ],
    );
  }

  void addNewSection() {
    String sectionName = sectionController.text.trim();
    if (sectionName.isNotEmpty) {
      widget.sectionsReference
          .doc(sectionName)
          .set({'details': 'Your Section Details Here'});
      Navigator.of(context).pop(sectionName);
    }
  }
}
