import 'package:flutter/material.dart';

class AddBranchPage extends StatefulWidget {
  @override
  _AddBranchPageState createState() => _AddBranchPageState();
}

class _AddBranchPageState extends State<AddBranchPage> {
  TextEditingController branchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Branch"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: branchController,
              decoration: InputDecoration(labelText: 'Branch'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Pass the added branch back to the Teacher page
                Navigator.pop(context, branchController.text);
              },
              child: Text('Add Branch'),
            ),
          ],
        ),
      ),
    );
  }
}
