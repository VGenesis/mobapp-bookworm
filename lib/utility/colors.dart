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
    secondary:      Colors.blue[400]!,
    onSecondary:    Colors.white,
    tertiary:       Colors.blue[200]!,
    onTertiary:     Colors.white,
    error:          Colors.red,
    onError:        Colors.white,
    surface:        Colors.white,
    onSurface:      Colors.blue,
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
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      if(states.contains(WidgetState.pressed)) {
        return Colors.blue[200];
      }
      return Colors.blue[700];
    }),
    thumbIcon: WidgetStateProperty.all(const Icon(null)),
    trackOutlineColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      return Colors.white;
    }),

  )
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme(
    brightness:     Brightness.light,
    primary:        Color.alphaBlend(Colors.black87, Colors.white),
    onPrimary:      Colors.white,
    secondary:      Color.alphaBlend(Colors.black87, Colors.white),
    onSecondary:    Colors.white,
    tertiary:       Color.alphaBlend(Colors.black54, Colors.white),
    onTertiary:     Colors.white,
    error:          Colors.red,
    onError:        Colors.red[400]!,
    surface:        Colors.black,
    onSurface:      Colors.white
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
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states){
      if(states.contains(WidgetState.pressed)) {
        return Colors.black;
      }
      return Colors.black38;
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


