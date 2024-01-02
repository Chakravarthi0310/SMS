import 'package:flutter/material.dart';
import 'AddSectionDialog.dart';
import 'Students.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Sections extends StatelessWidget {
  final String branch;
  final String academicYear;
  final CollectionReference sectionsReference;

  const Sections({
    required this.branch,
    required this.academicYear,
    required this.sectionsReference,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sections - $academicYear"),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddSectionDialog(
                    sectionsReference: sectionsReference,
                  );
                },
              ).then((value) {
                if (value != null && value is String) {
                  // Handle section added callback if needed
                }
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: sectionsReference.snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }

            var sections = snapshot.data!.docs;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var section in sections)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Students(
                            branch: branch,
                            academicYear: academicYear,
                            section: section.id,
                            // Add more parameters as needed
                          ),
                        ),
                      );
                    },
                    child: Text(section.id),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
