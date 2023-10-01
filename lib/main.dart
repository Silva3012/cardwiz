// Flutter Material package
import 'package:flutter/material.dart';

// Starting point of the app
void main() => runApp(CardWiz());

// CardWiz class represents the main application
class CardWiz extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Base widget of the app
    return MaterialApp(
      title: "CardWiz",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark
      ),
      home: Scaffold(
        // Add the app bar at the top
        appBar: AppBar(
          title: Text("Card Wiz"),
        )
      ),
    );
  }
}


