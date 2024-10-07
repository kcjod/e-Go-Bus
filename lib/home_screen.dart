import 'package:ego_bus/pages/driver_pages/dashboard.dart';
import 'package:ego_bus/pages/management_pages/dashboard.dart';
import 'package:ego_bus/pages/parent_pages/dashboard.dart';
import 'package:ego_bus/pages/who_are_you.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    String? loginType = prefs.getString('login_type');

    if (isLoggedIn != null && isLoggedIn) {
      if (loginType == 'driver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DriverDashboard()),
        );
      } else if (loginType == 'management') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ManagementDashboard()),
        );
      } else if (loginType == 'parent') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ParentDashboard()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between logo and button
        children: [
          // Centered logo and caption
          Expanded(
            child: Center( // Centering the logo vertically
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage("assets/images/logo.webp"),
                    radius: 50,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Some caption goes here..",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button at the bottom
          Container(
            width: double.infinity, // Makes the button cover the entire width
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => WhoAreYou()),
                );
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  letterSpacing: 1.1,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0), // No border radius
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.pinkAccent,
    );
  }
}
