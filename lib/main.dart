import 'package:employee_attendance_app/views/attendance_history.dart';
import 'package:employee_attendance_app/views/home_page.dart';
import 'package:employee_attendance_app/views/login_page.dart';
import 'package:employee_attendance_app/views/registration_page.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) =>const RegistrationPage(),
        "login": (context) =>const  LogIn(),
        "home":(context) => const HomePage(),
        "history":(context) => const AttendanceHistory(),
      },
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
