import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';
import 'student.dart';
import 'teacher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue[900],
      ),
      home: _handleAuth(),
    );
  }

  Widget _handleAuth() {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            // User not logged in, redirect to login page
            return LoginPage();
          } else {
            // User is logged in, fetch role and navigate to the appropriate screen
            return FutureBuilder<String>(
              future: _getUserRole(user.uid),
              builder:
                  (BuildContext context, AsyncSnapshot<String> roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.done) {
                  String role = roleSnapshot.data ?? "";

                  if (role == "Student") {
                    return Student();
                  } else if (role == "Teacher") {
                    return Teacher();
                  } else {
                    // Handle other roles or unexpected scenarios
                    print('Unknown role: $role');
                    return LoginPage();
                  }
                } else {
                  // Still fetching role data
                  return CircularProgressIndicator();
                }
              },
            );
          }
        } else {
          // Waiting for the connection to Firebase Auth
          return CircularProgressIndicator();
        }
      },
    );
  }

  Future<String> _getUserRole(String uid) async {
    try {
      DocumentSnapshot documentSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('rool') ??
            ""; // Check if the field name is 'rool' or 'role'
      } else {
        // Handle the case where the user document doesn't exist
        print('User document does not exist for UID: $uid');
        return "";
      }
    } catch (e) {
      // Handle errors
      print('Error fetching user role: $e');
      return "";
    }
  }
}
