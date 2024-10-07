import 'package:ego_bus/pages/driver_pages/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverLogin extends StatefulWidget {
  const DriverLogin({super.key});

  @override
  _DriverLoginState createState() => _DriverLoginState();
}

class _DriverLoginState extends State<DriverLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _schoolIdController = TextEditingController();
  final TextEditingController _driverIdController = TextEditingController();
  final TextEditingController _busIdController = TextEditingController();

  String _errorMessage = '';

  @override
  void dispose() {
    _schoolIdController.dispose();
    _driverIdController.dispose();
    _busIdController.dispose();
    super.dispose();
  }

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String schoolID = _schoolIdController.text.trim();
      final String driverID = _driverIdController.text.trim();
      final String busID = _busIdController.text.trim();

      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('driver') // Make sure to use the correct collection
            .doc(driverID)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          // Check if the school ID matches
          if (data['schoolId'] == schoolID) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('login_type', 'driver');
            await prefs.setString('driverId', driverID);

            // If bus ID is provided, check if it matches or leave it out
            if (busID.isEmpty || data['busId'] == busID) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => DriverDashboard()),
                  (Route<dynamic> route) => false);
            } else {
              setState(() {
                _errorMessage = 'Invalid Bus ID for this driver.';
              });
            }
          } else {
            setState(() {
              _errorMessage = 'Invalid credentials, please try again.';
            });
          }
        } else {
          setState(() {
            _errorMessage = 'No user found with that Driver ID.';
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
        title: Text('Driver Login'),
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
                "Driver Login",
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
                controller: _driverIdController,
                decoration: InputDecoration(
                  labelText: 'Driver ID',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your Driver ID';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _busIdController,
                decoration: InputDecoration(
                  labelText: 'Bus ID (Optional)',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
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
