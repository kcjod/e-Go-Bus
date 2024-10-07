import 'package:ego_bus/pages/who_are_you.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({Key? key}) : super(key: key);

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  int _selectedIndex = 1;
  String? _errorMessage;
  Map<String, dynamic>?
      parentDetails; // Declare parentDetails to hold fetched data

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Check login status on initialization
    _fetchParentDetails(); // Automatically fetch parent details on init
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

  List<Widget> _pages() {
    return [
      Center(child: Text("Driver Page")),
      Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: Center(
              child: Text("Map (Live Tracking)"),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    "7 min",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Parent/Student Details",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            if (parentDetails != null) // Display parent details
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // Align text to the start
                children: [
                  Text("Full Name: ${parentDetails!['fullName']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Parent Name: ${parentDetails!['parentName']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Bus ID: ${parentDetails!['busId']}",
                      style: TextStyle(fontSize: 18)),
                  Text("School ID: ${parentDetails!['schoolId']}",
                      style: TextStyle(fontSize: 18)),
                  Text("Student ID: ${parentDetails!['studentId']}",
                      style: TextStyle(fontSize: 18)),
                ],
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _logout(); // Log out user
              },
              child: Text("Logout"),
            ),
            if (_errorMessage != null) // Check if there's an error message
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    ];
  }

  Future<void> _fetchParentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? parentId = prefs.getString('parentId'); // Get parentId from prefs

    if (parentId != null) {
      try {
        DocumentSnapshot document = await FirebaseFirestore.instance
            .collection('parent')
            .doc(parentId)
            .get();

        if (document.exists) {
          parentDetails = document.data() as Map<String, dynamic>;

          // Store the fetched parent details in SharedPreferences
          await prefs.setString('parentDetails', document.data().toString());
          setState(() {}); // Trigger UI update
        } else {
          setState(() {
            _errorMessage = 'No parent details found for the provided ID.';
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'Failed to fetch parent details: $error';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Parent ID is not available.';
      });
    }
  }

  Future<void> _logout() async {
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
      setState(() {
        _errorMessage = 'Logout failed: ${error.toString()}';
      });
      print('Error during logout: $error');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
      body: Column(
        children: [
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              reverse: false,
              transitionBuilder: (Widget child, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                );
              },
              child: _pages()[_selectedIndex], // Call the method here
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Transform.scale(
            scale: _selectedIndex == 0 ? 2 : 1.0,
            child: CircleAvatar(
              backgroundColor: Colors.pinkAccent,
              child: Icon(Icons.drive_eta, color: Colors.white),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.scale(
            scale: _selectedIndex == 1 ? 2 : 1.0,
            child: CircleAvatar(
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.location_pin, color: Colors.white),
            ),
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Transform.scale(
            scale: _selectedIndex == 2 ? 2 : 1.0,
            child: CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          label: '',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Colors.white,
      backgroundColor: Colors.pinkAccent,
      unselectedItemColor: Colors.white70,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ParentMenu(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset(0.2, 0.0);
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
