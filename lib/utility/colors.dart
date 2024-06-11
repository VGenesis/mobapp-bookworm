import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    tertiary:       Colors.red,
    onTertiary:     Colors.white,
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

  switchTheme:  SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      return Colors.blue;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      if(states.contains(WidgetState.pressed)) {
        return Colors.white;
      }
      return Colors.grey;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      return Colors.white;
    }),

  )
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness:     Brightness.dark,
    primary:        Colors.black54,
    onPrimary:      Colors.black,
    secondary:      Colors.black54,
    onSecondary:    Colors.black,
    tertiary:       Colors.red,
    onTertiary:     Colors.white,
    error:          Colors.red,
    onError:        Colors.red[400]!,
    surface:        Colors.grey,
    onSurface:      Colors.white
  ),

  textTheme: const TextTheme(
    titleLarge: TextStyle(
      fontSize: 32,
      color: Colors.black
    ),

    titleMedium: TextStyle(
      fontSize: 20,
      color: Colors.black
    ),

    titleSmall: TextStyle(
      fontSize: 16,
      color: Colors.black
    ),

    displayMedium: TextStyle(
      fontSize: 24,
      color: Colors.white
    ),

    displaySmall: TextStyle(
      fontSize: 16,
      color: Colors.white
    ),
  ),

  switchTheme:  SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      return Colors.orange;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      if(states.contains(WidgetState.pressed)) {
        return Colors.black;
      }
      return Colors.grey;
    }),
    trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      return Colors.black;
    }),

  )
);

class PageTheme extends ChangeNotifier{
  ThemeData theme = lightTheme;

  void swapTheme(){
    theme = (theme == lightTheme)
      ? darkTheme : lightTheme;
    notifyListeners();
  }
}


