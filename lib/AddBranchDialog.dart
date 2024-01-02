import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddBranchDialog extends StatefulWidget {
  final FirebaseFirestore firestore;
  final Function(String) onBranchAdded;

  const AddBranchDialog({
    Key? key,
    required this.firestore,
    required this.onBranchAdded,
  }) : super(key: key);

  @override
  _AddBranchDialogState createState() => _AddBranchDialogState();
}

class _AddBranchDialogState extends State<AddBranchDialog> {
  final TextEditingController _branchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Branch'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _branchController,
              decoration: InputDecoration(labelText: 'Branch'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            String branchName = _branchController.text.trim();
            if (branchName.isNotEmpty) {
              await widget.firestore
                  .collection('branches')
                  .doc(branchName)
                  .set({});
              widget.onBranchAdded(branchName);
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
