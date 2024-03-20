import 'package:bookworm/pages/homepage.dart';
import 'package:bookworm/pages/profilepage.dart';
import 'package:bookworm/pages/searchpage.dart';
import 'package:flutter/material.dart';

class Mainpage extends StatefulWidget {
    const Mainpage({super.key});

    @override
        State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
    int selectedNavPage = 0;
    List<Widget > pages = [
        const Homepage(),
        const SearchPage(),
        const ProfilePage()
    ];

    static const List<String> pageNames = [
        "Home",
        "Search",
        "Profile"
    ];

    @override Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(pageNames[selectedNavPage]),
                centerTitle: true,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black87
                ),

            body: Container(
                color: Colors.black,
                child: pages[selectedNavPage]
            ),

            bottomNavigationBar: BottomNavigationBar(
                selectedItemColor: Colors.blue[400],
                //selectedLabelStyle: const TextStyle(color: Colors.white),
                unselectedItemColor: Colors.white,
                //unselectedLabelStyle: const TextStyle(color: Colors.white54),
                backgroundColor: Colors.black87,
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
        );
    }
}
