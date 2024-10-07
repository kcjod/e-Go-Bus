import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ego_bus/pages/driver_pages/menu.dart';
import 'package:ego_bus/pages/who_are_you.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({super.key});

  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  String driverId = '';
  String driverName = '';
  String schoolId = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on initialization
    _fetchDriverData(); // Fetch driver data on initialization
  }

  // Check if the user is logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');

    if (isLoggedIn == null || !isLoggedIn) {
      // If not logged in, navigate to the login page (WhoAreYou)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WhoAreYou()),
      );
    }
  }

  Future<void> _fetchDriverData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    driverId = prefs.getString('driverId') ?? '';

    if (driverId.isNotEmpty) {
      try {
        // Fetch driver data based on driverId
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('driver')
            .doc(driverId)
            .get();

        if (doc.exists) {
          final data = doc.data() as Map<String, dynamic>;

          // Store the driver details in SharedPreferences
          await prefs.setString('driverName', data['driverName']);
          await prefs.setString('schoolId', data['schoolId']);

          // Update the state with the fetched data
          setState(() {
            driverName = data['driverName'];
            schoolId = data['schoolId'];
          });
        } else {
          setState(() {
            _errorMessage = 'No driver found with that ID.';
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Failed to fetch driver data: ${error.toString()}';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Driver ID not found in preferences.';
      });
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
        child: _errorMessage.isNotEmpty
            ? Text(
          _errorMessage,
          style: TextStyle(color: Colors.red),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Driver Dashboard", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            Text("Driver ID: $driverId", style: TextStyle(fontSize: 18)),
            Text("Driver Name: $driverName", style: TextStyle(fontSize: 18)),
            Text("School ID: $schoolId", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => DriverMenu(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset(0.2, 0.0);
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      opaque: false,
    );
  }
}
