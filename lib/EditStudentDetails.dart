import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudentDetails extends StatefulWidget {
  final User? user;

  const EditStudentDetails({Key? key, required this.user}) : super(key: key);

  @override
  _EditStudentDetailsState createState() => _EditStudentDetailsState();
}

class _EditStudentDetailsState extends State<EditStudentDetails> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing user details
    nameController.text = widget.user?.displayName ?? '';
    emailController.text = widget.user?.email ?? '';
    // You can add phone information if available
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
            ElevatedButton(
              onPressed: () {
                saveChanges();
              },
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }

  void saveChanges() {
    // Save changes to Firestore or any other storage
    // Update user's display name
    widget.user?.updateDisplayName(nameController.text);
    // Update other details as needed

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Changes saved successfully!'),
      ),
    );

    Navigator.pop(context); // Navigate back after saving changes
  }
}
