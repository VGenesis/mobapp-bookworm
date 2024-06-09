import 'package:flutter/material.dart';

List<Color> cBlack = [
    Colors.black,
    Colors.black87,
    Colors.black54,
    Colors.black45,
    Colors.black38,
    Colors.black26,
    Colors.black12
];

List<Color> cWhite = [
    Colors.white,
    Colors.white70,
    Colors.white60,
    Colors.white54,
    Colors.white38,
    Colors.white24,
    Colors.white12,
];

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme(
        brightness:     Brightness.light,
        primary:        Colors.blue,
        onPrimary:      Colors.white,
        secondary:      Colors.blueAccent,
        onSecondary:    Colors.white54,
        error:          Colors.red,
        onError:        Colors.red[400]!,
        surface:        Colors.blueGrey,
        onSurface:      Colors.white54
    ),

    textTheme: const TextTheme(
        titleLarge: TextStyle(
            fontSize: 32,
            color: Colors.white
        ),

        titleMedium: TextStyle(
            fontSize: 20,
            color: Colors.white
        ),

        titleSmall: TextStyle(
            fontSize: 16,
            color: Colors.white
        ),


        displayMedium: TextStyle(
            fontSize: 24,
            color: Colors.black
        ),

        displaySmall: TextStyle(
            fontSize: 16,
            color: Colors.black
        ),
    ),
);

