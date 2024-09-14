import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled1/main.dart';
import 'database/DatabaseHelper.dart';
import 'database_helper.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  HomeScreen({required this.username});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadCounter(); // Load the current user's counter value when the screen is initialized
  }

  // Load the current user's counter value from SQLite
  void _loadCounter() async {
    int counterValue = await _dbHelper.getCounter(widget.username);
    setState(() {
      _counter = counterValue;
    });
  }

  // Increment the counter and update the value in SQLite
  void _incrementCounter() async {
    setState(() {
      _counter++;
    });
    await _dbHelper.updateCounter(widget.username, _counter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: Text('Welcome, ${widget.username}'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate back to login screen
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Your counter value is:  $_counter',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18 ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
