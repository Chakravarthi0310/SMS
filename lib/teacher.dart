import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'AcademicYears.dart';
import 'login.dart';
import 'AddBranchDialog.dart';
import 'SearchPage.dart';

class Teacher extends StatefulWidget {
  const Teacher({Key? key}) : super(key: key);

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  List<String> branches = [];

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  void fetchBranches() async {
    try {
      QuerySnapshot querySnapshot =
          await firestore.collection('branches').get();
      setState(() {
        branches = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  // Function to navigate to the search page
  void navigateToSearchPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(branches: branches),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher"),
        actions: [
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Branches",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            for (var branch in branches)
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AcademicYears(branch: branch),
                    ),
                  );
                },
                child: Text(branch),
              ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Search Button
          FloatingActionButton(
            onPressed: navigateToSearchPage, // Call the navigate function
            child: Icon(Icons.search),
          ),
          // Add Button
          FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AddBranchDialog(
                    firestore: firestore,
                    onBranchAdded: (String branch) {
                      // Handle branch added callback if needed
                      fetchBranches();
                    },
                  );
                },
              );
            },
            child: Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    CircularProgressIndicator();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
