import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  final dobController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadDOB();
  }

  void loadDOB() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      dobController.text = doc['dob'] ?? '';
    }
  }

  void updateDOB() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'dob': dobController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("DOB updated")));
    }
  }

  void changePassword() async {
    try {
      await _auth.currentUser!.updatePassword(newPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password changed")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password change failed")));
    }
  }

  void logout() async {
    await _auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: dobController, decoration: InputDecoration(labelText: 'Date of Birth')),
            ElevatedButton(onPressed: updateDOB, child: Text("Update DOB")),
            Divider(),
            TextField(controller: newPasswordController, decoration: InputDecoration(labelText: 'New Password'), obscureText: true),
            ElevatedButton(onPressed: changePassword, child: Text("Change Password")),
            Divider(),
            ElevatedButton(onPressed: logout, child: Text("Log Out")),
          ],
        ),
      ),
    );
  }
}