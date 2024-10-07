import 'package:ego_bus/pages/driver_login.dart';
import 'package:ego_bus/pages/management_login.dart';
import 'package:ego_bus/pages/parent_login.dart';
import 'package:flutter/material.dart';

class WhoAreYou extends StatelessWidget {
  const WhoAreYou({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(child: Text("Tell us who you are...",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w600,color: Colors.pinkAccent),)),
              ),
              SizedBox(height: 20,),
              Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ManagementLogin()));
                  },
                  child: Text(
                    "School Management",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0), // Border radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ParentLogin()));
                  },
                  child: Text(
                    "Parent",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0), // Border radius
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                width: 400,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DriverLogin()));
                  },
                  child: Text(
                    "Bus Driver",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      letterSpacing: 1.1,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent, // Background color
                    foregroundColor: Colors.white, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0), // Border radius
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // backgroundColor: Colors.pinkAccent,
    );
  }
}
