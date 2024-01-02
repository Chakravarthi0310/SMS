// student.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login.dart';
import 'StudentProfile.dart'; // Import the new file

class Student extends StatefulWidget {
  const Student({Key? key}) : super(key: key);

  @override
  State<Student> createState() => _StudentState();
}

class _StudentState extends State<Student> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedBranch = "";
  String selectedAcademicYear = "";
  String selectedSection = "";

  TextEditingController rollNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  List<String> branches = [];
  List<String> academicYears = [];
  List<String> sections = [];

  @override
  void initState() {
    super.initState();
    fetchBranches();
  }

  bool loading = false;
  bool academicYearsSelected = false;
  bool branchSelected = false;

  void fetchBranches() async {
    try {
      setState(() {
        loading = true;
      });
      QuerySnapshot querySnapshot =
          await _firestore.collection('branches').get();
      setState(() {
        branches = querySnapshot.docs.map((doc) => doc.id).toList();
        if (branches.isNotEmpty) {
          selectedBranch = branches[0];
        }
        loading = false;
      });
    } catch (e) {
      print('Error fetching branches: $e');
    }
  }

  void fetchAcademicYears() async {
    try {
      setState(() {
        loading = true;
      });
      if (selectedBranch.isNotEmpty) {
        QuerySnapshot querySnapshot = await _firestore
            .collection('branches')
            .doc(selectedBranch)
            .collection('academicYears')
            .get();

        setState(() {
          academicYears = querySnapshot.docs.map((doc) => doc.id).toList();
          if (academicYears.isNotEmpty) {
            selectedAcademicYear = academicYears[0];
          }
          loading = false;
        });
      }
    } catch (e) {
      print('Error fetching academic years: $e');
    }
  }

  void fetchSections() async {
    try {
      setState(() {
        loading = true;
      });
      QuerySnapshot querySnapshot = await _firestore
          .collection('branches')
          .doc(selectedBranch)
          .collection('academicYears')
          .doc(selectedAcademicYear)
          .collection('sections')
          .get();
      setState(() {
        sections = querySnapshot.docs.map((doc) => doc.id).toList();
        if (sections.isNotEmpty) {
          selectedSection = sections[0];
        }
        loading = false;
      });
    } catch (e) {
      print('Error fetching sections: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student"),
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
      body: loading
          ? CircularProgressIndicator()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildOptionList("Branch", branches, selectedBranch,
                      (String value) {
                    setState(() {
                      selectedBranch = value;
                      fetchAcademicYears();
                      branchSelected = true;
                    });
                  }),
                  branchSelected
                      ? buildOptionList(
                          "Academic Year", academicYears, selectedAcademicYear,
                          (String value) {
                          setState(() {
                            selectedAcademicYear = value;
                            fetchSections();
                            academicYearsSelected = true;
                          });
                        })
                      : Container(),
                  academicYearsSelected
                      ? buildOptionList("Section", sections, selectedSection,
                          (String value) {
                          setState(() {
                            selectedSection = value;
                          });
                        })
                      : Container(),
                  TextField(
                    controller: rollNumberController,
                    decoration: InputDecoration(labelText: 'Roll Number'),
                  ),
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
                      addStudentDetails();
                    },
                    child: Text("Add Details"),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      navigateToProfile();
                    },
                    child: Text("View Profile"),
                  ),
                  SizedBox(height: 16),
                  StudentProfile(
                    user: _auth.currentUser,
                    selectedBranch: selectedBranch,
                    selectedAcademicYear: selectedAcademicYear,
                    selectedSection: selectedSection,
                  ), // Use the new widget here
                ],
              ),
            ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  void addStudentDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final studentRef = _firestore
            .collection('branches')
            .doc(selectedBranch)
            .collection('academicYears')
            .doc(selectedAcademicYear)
            .collection('sections')
            .doc(selectedSection)
            .collection('students')
            .doc(user.uid);

        await studentRef.set({
          'branch': selectedBranch,
          'academicYear': selectedAcademicYear,
          'section': selectedSection,
          'rollNumber': rollNumberController.text,
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        });

        await user.updateDisplayName(
            nameController.text); // Update display name with the name

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student details added successfully!'),
          ),
        );

        navigateToProfile();
      }
    } catch (e) {
      print('Error adding student details: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add student details.'),
        ),
      );
    }
  }

  void navigateToProfile() {
    User? user = _auth.currentUser;
    if (user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StudentProfile(
            user: user,
            selectedBranch: selectedBranch,
            selectedAcademicYear: selectedAcademicYear,
            selectedSection: selectedSection,
          ),
        ),
      );
    }
  }

  Widget buildOptionList(String label, List<String> items, String selectedValue,
      Function(String) onChanged) {
    if (items.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(label),
          SizedBox(height: 8),
          DropdownButton<String>(
            value: selectedValue,
            onChanged: (value) {
              setState(() {
                selectedValue = value!;
              });
              onChanged(value!);
            },
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }).toList(),
            hint: Text(label),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}
