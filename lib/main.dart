import 'package:bookworm/pages/bookpage.dart';
import 'package:flutter/material.dart';

import 'package:bookworm/utility/colors.dart';
import 'package:bookworm/pages/mainpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
    State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeData theme = lightTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      theme: theme,
      home: const Mainpage()
    );
  }
}
