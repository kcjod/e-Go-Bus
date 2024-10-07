import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ego_bus/pages/who_are_you.dart'; // Adjust import as needed

class DriverMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Changed to white
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.80,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Menu Item 1",
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Menu Item 2",
                              style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Menu Item 3",
                              style: TextStyle(color: Colors.black)),
                        ),
                        // Logout Button
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              await _logout(context);
                            },
                            child: Text("Logout"),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.80,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .pop(); // Close the menu on background tap
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.20,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Clear SharedPreferences or other session data
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Navigate to the WhoAreYou screen (login page) using pushReplacement
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WhoAreYou()),
          (Route<dynamic> route) => false);
    } catch (error) {
      // Handle logout errors if needed
      print('Error during logout: $error');
    }
  }
}
