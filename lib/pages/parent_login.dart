import 'package:ego_bus/pages/parent_pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentLogin extends StatefulWidget {
  const ParentLogin({super.key});

  @override
  _ParentLoginState createState() => _ParentLoginState();
}

class _ParentLoginState extends State<ParentLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _schoolIdController.dispose();
    _studentIdController.dispose();
    _busIdController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String schoolID = _schoolIdController.text.trim();
      final String studentID = _studentIdController.text.trim();
      final String busID = _busIdController.text.trim();

      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('parent')
            .doc(studentID)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          if (data['schoolId'] == schoolID && data['busId'] == busID) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('login_type', 'parent');
            await prefs.setString('parentId', studentID);

            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ParentDashboard()),
                (Route<dynamic> route) => false);
          } else {
            setState(() {
              _errorMessage = 'Invalid credentials, please try again.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No user found with that Student ID.';
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Login failed: ${error.toString()}';
        });
        print('Error during login: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Login'),
        backgroundColor: Colors.pinkAccent,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Parent Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pinkAccent,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _schoolIdController,
                decoration: InputDecoration(
                  labelText: 'School ID',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your School ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _studentIdController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Student ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _busIdController,
                decoration: InputDecoration(
                  labelText: 'Bus ID',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Bus ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pinkAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
