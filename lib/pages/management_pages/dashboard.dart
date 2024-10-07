import 'package:ego_bus/pages/management_pages/menu.dart';
import 'package:ego_bus/pages/who_are_you.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManagementDashboard extends StatefulWidget {
  const ManagementDashboard({super.key});

  @override
  _ManagementDashboardState createState() => _ManagementDashboardState();
}

class _ManagementDashboardState extends State<ManagementDashboard> {
  Map<String, dynamic>? managementDetails; // To hold fetched data
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on initialization
    _loadManagementDetailsFromPrefs(); // Load management details from SharedPreferences first
    _fetchManagementDetails(); // Fetch management details from Firestore
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == null || !isLoggedIn) {
      // If not logged in, navigate to the login page (WhoAreYou)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WhoAreYou()),
      );
    }
  }

  // Fetch management details from Firestore
  Future<void> _fetchManagementDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? schoolId = prefs.getString('schoolId'); // Get schoolId from prefs

    if (schoolId != null) {
      try {
        DocumentSnapshot document = await FirebaseFirestore.instance
            .collection('management')
            .doc(schoolId)
            .get();

        if (document.exists) {
          managementDetails = document.data() as Map<String, dynamic>;

          // Store management details in SharedPreferences for offline use
          await prefs.setString('managementDetails', managementDetails.toString());

          setState(() {});
        } else {
          setState(() {
            _errorMessage = 'No management details found for the provided ID.';
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Failed to fetch management details: $error';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'School ID is not available.';
      });
    }
  }

  // Load management details from SharedPreferences
  Future<void> _loadManagementDetailsFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? managementDetailsString = prefs.getString('managementDetails');

    if (managementDetailsString != null) {
      // Convert the stored string back to a Map
      Map<String, dynamic> loadedDetails = {};
      managementDetailsString.split(', ').forEach((element) {
        var keyValue = element.split(': ');
        if (keyValue.length == 2) {
          loadedDetails[keyValue[0]] = keyValue[1];
        }
      });

      managementDetails = loadedDetails;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "e-Go Bus",
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
        ],
        backgroundColor: Colors.pinkAccent,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: managementDetails != null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("School Name: ${managementDetails!['schoolName']}", style: TextStyle(fontSize: 18)),
            Text("School ID: ${managementDetails!['schoolId']}", style: TextStyle(fontSize: 18)),
            Text("Number of Buses: ${managementDetails!['noOfBuses']}", style: TextStyle(fontSize: 18)),
            Text("Number of Students: ${managementDetails!['noOfStudents']}", style: TextStyle(fontSize: 18)),
          ],
        )
            : _errorMessage != null
            ? Text(
          _errorMessage!,
          style: TextStyle(color: Colors.red),
        )
            : CircularProgressIndicator(),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ManagementMenu(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset(0.2, 0.0); // Stop at 20% from the left (80% width)
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      opaque: false, // Allow the background to be partially visible
    );
  }
}
