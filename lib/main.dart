import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flight_tickets/theme.dart';
import 'package:flight_tickets/screens/home_screen.dart';
import 'dart:io';

Future<void> main() async { 
    //For connecting the database for testing puposes
    final FireBaseApp = await FirebaseApp.configure(
        name: 'flight-firestore',
        options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:358307475635:ios:3d28f31956c2c0dc',
            gcmSenderID: '358307475635',
            databaseURL: 'https://airlines-app-c8770.firebaseio.com/'
        )  : const FirebaseOptions(
            googleAppID: '',
            apiKey: '',
            databaseURL: 'https://airlines-app-c8770.firebaseio.com/'
        )
    );
    
    runApp(MaterialApp(
        title: "Flight Reservation",
        debugShowCheckedModeBanner: false,
        home: MyApp(),
        theme: appTheme,
    ));
}

//Theme Customizations
ThemeData appTheme = ThemeData(
    primaryColor: Color(0xFFF3791A),
    fontFamily: 'Oxygen'
);

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

    @override
    void initState() {
        super.initState();
        Future.delayed(
            Duration(seconds: 3),
            () {
                Navigator.push(context, 
                MaterialPageRoute(
                    builder: (context) => HomeScreen()
                ));
            }
        );
    }
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            body: Center(
                child: Text("Airlines✈️",
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.black,
                ),
                ),
            ),
        );
    }
}