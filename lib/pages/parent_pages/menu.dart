import 'package:flutter/material.dart';

class ParentMenu extends StatelessWidget {
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
                          child: Text("Menu Item 1", style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Menu Item 2", style: TextStyle(color: Colors.black)),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text("Menu Item 3", style: TextStyle(color: Colors.black)),
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
                  Navigator.of(context).pop(); // Close the menu on background tap
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
}