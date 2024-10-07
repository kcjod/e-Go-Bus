import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ego_bus/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
    });

    Timer.periodic(Duration(milliseconds: 200), (Timer timer) {
      setState(() {
        _progress += 0.1;
        if (_progress >= 1.0) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "e-Go Bus",
              style: TextStyle(
                fontSize: 60,
                letterSpacing: .8,
                color: Colors.pinkAccent,
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 100,
              child: LinearProgressIndicator(
                value: _progress, // Display progress
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
