import 'package:aide/Remind.dart';
import 'package:aide/Secure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aide/auth.dart';
import 'package:aide/login.dart';
import 'package:aide/Create.dart';
import 'package:aide/list.dart';

void main() => runApp(TODOApp());

// The sole reason we keep this extra component is
// because runApp will only take a StatelessWidget as its argument
class TODOApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TODO();
  }
}

// Here we are defining a StatefulWidget
class TODO extends StatefulWidget {
  // Every stateful widget must override createState
  @override
  State<StatefulWidget> createState() {
    return TODOState();
  }
}

class TODOState extends State<TODO> {
  // Creating a list of tasks with some fake data
  final Authentication auth = new Authentication();
  FirebaseUser user;

  void onLogin(FirebaseUser user) {
    setState(() {
        this.user = user;
    });
  }

  // This widget is the root of your application.
  // Now state is responsible for building the widget
  @override
  Widget build(BuildContext context) {
    // Instead of rendering content, we define routes for different screens
    // in our app
    return MaterialApp(
      title: 'Welcome to Aide',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        // Screen to view tasks
        '/': (context) => TODOLogin(onLogin: onLogin),
        '/list': (context) => TODOList(),
        // Screen to create tasks
        '/create': (context) => TODOCreate(),
        '/remind': (context) => RemindCreate(),
        '/secure': (context) => SecureCreate(),
      },
    );
  }
}
