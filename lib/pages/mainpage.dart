import 'package:bookworm/pages/likedbooks.dart';
import 'package:bookworm/utility/colors.dart';
import 'package:flutter/material.dart';

import 'package:bookworm/pages/homepage.dart';
import 'package:bookworm/pages/profilepage.dart';
import 'package:bookworm/pages/searchpage.dart';
import 'package:provider/provider.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
    State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> with WidgetsBindingObserver{
  int selectedNavPage = 0;

  List<Widget> pages = [
    const Homepage(),
    const SearchPage(),
    const ProfilePage()
  ];

  static const List<String> pageNames = [
    "Home",
    "Search",
    "Favorites"
  ];

  static bool switchDarkTheme = false;

  @override void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LikedBooks.loadBooks();
  }

  @override void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if(
      state == AppLifecycleState.detached ||
      state == AppLifecycleState.inactive
    ){
      LikedBooks.saveBooks();
    }
  }

  @override void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override Widget build(BuildContext context) {
    return Consumer<PageTheme>(
    builder: (context, currentTheme, child) => Scaffold(
        appBar: AppBar(
          title: Text(pageNames[selectedNavPage]),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SwitchTheme(
                data: currentTheme.theme.switchTheme,
                child: Switch(
                  value: switchDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      switchDarkTheme = value;
                      currentTheme.swapTheme();
                    });
                  }
                )
              ),
            )
          ],
          centerTitle: true,
          foregroundColor: currentTheme.theme.textTheme.titleLarge!.color,
          backgroundColor: currentTheme.theme.colorScheme.primary
        ),
      
        body: Container(
          color: currentTheme.theme.colorScheme.surface,
          child: pages[selectedNavPage],
        ),
      
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: currentTheme.theme.colorScheme.onPrimary,
          unselectedItemColor: currentTheme.theme.colorScheme.onSecondary,
          backgroundColor: currentTheme.theme.colorScheme.primary,
          currentIndex: selectedNavPage,
          onTap: (value) => {
          setState(() {
              selectedNavPage = value;
              }),
          },
          items: [
              BottomNavigationBarItem(icon: const Icon(Icons.home), label: pageNames[0]),
              BottomNavigationBarItem(icon: const Icon(Icons.search), label: pageNames[1]),
              BottomNavigationBarItem(icon: const Icon(Icons.person), label: pageNames[2]),
          ]
        ),
      ),
    );
  }
}
