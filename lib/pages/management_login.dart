import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ego_bus/pages/management_pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementLogin extends StatefulWidget {
  const ManagementLogin({super.key});

  @override
  _ManagementLoginState createState() => _ManagementLoginState();
}

class _ManagementLoginState extends State<ManagementLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _schoolIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String schoolID = _schoolIdController.text.trim();
      final String password = _passwordController.text.trim();

      try {
        // Fetch management data based on schoolID
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('management')
            .doc(schoolID)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          // Check if the password matches
          if (data['password'] == password) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('login_type', 'management');
            await prefs.setString('schoolId', schoolID);

            // Navigate to Management Dashboard upon successful login
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => ManagementDashboard()),
                (Route<dynamic> route) => false);
          } else {
            setState(() {
              _errorMessage = 'Invalid credentials, please try again.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No user found with that School ID.';
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
        title: Text('Management Login'),
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
                "Management Login",
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
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle Forgot Password logic
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
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
