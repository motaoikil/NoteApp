import 'package:flutter/material.dart';
import 'package:notes_app/database/MySqldatabase.dart';
import 'package:notes_app/pages/AddNote.dart';
import 'package:notes_app/auth/Loging.dart';
import 'package:notes_app/auth/Register.dart';
import 'package:notes_app/pages/EditNote.dart';
import 'package:notes_app/pages/HomePage.dart';
import 'package:notes_app/pages/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  MySqldatabase().createTableUSER();
  MySqldatabase().createTableNote();
  return runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
    routes: {
      "Login": (((context) => Login().build(context))),
      "Register": ((context) => Register().build(context)),
      "HomePage": ((context) => HomePage().build(context)),
      "AddNote": ((context) => AddNote().build(context)),
      "Settings": ((context) => Settings().build(context)),
      "Editnote": ((context) => Editnote().build(context))
    },
    theme: ThemeData(

        // primarySwatch: Colors.orange,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.amber,
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        fontFamily: "Ubuntu",
        primaryIconTheme: IconThemeData(color: Colors.white, size: 20),
        colorScheme: ColorScheme.light(
          primary: Colors.amber,
          secondary: Colors.white,
        ),
        splashColor: Colors.amber[300],
        primaryTextTheme: TextTheme(
          button: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          caption: TextStyle(
              color: Colors.amber, fontSize: 20, fontWeight: FontWeight.bold),
          headline1: TextStyle(
              color: Colors.amber,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              letterSpacing: 2),
        )),
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() {
    return routee();
  }
}

class routee extends State<MyApp> {
  getid() async {
    SharedPreferences sh = await SharedPreferences.getInstance();
    String ru = await sh.getString("ID_USER").toString();
    return ru;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getid(),
      builder: (context, snapshot) {
        if (snapshot.data == null && snapshot.data.toString().trim().isEmpty) {
          return HomePage().build(context);
        } else {
          return Login().build(context);
        }
      },
    );
  }
}
