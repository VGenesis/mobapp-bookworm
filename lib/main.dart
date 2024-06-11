import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworm/pages/splashscreen.dart';
import 'package:bookworm/utility/colors.dart';

void main() {
  runApp(
    ChangeNotifierProvider<PageTheme>(
      create: (context) => PageTheme(),
      child: const MyApp(),
    )
  );
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
      home: const SplashScreen()
    );
  }
}
