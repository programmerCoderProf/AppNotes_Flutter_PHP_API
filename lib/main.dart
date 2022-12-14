import 'package:app2/Home/homepage.dart';
import 'package:app2/crud/addnotes.dart';
import 'package:app2/auth/signup.dart';
import 'package:flutter/material.dart';
import 'package:app2/auth/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 214, 152, 148),
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: prefs.getString("id") == null ? "login" : "home",
        routes: {
          "login": (_) => Login(),
          "singup": (_) => SingUp(),
          "home": (_) => HomePage(),
          "addnotes": (_) => AddNotes(),
        });
  }
}
