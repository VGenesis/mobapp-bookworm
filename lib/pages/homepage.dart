import 'package:bookworm/pages/bookpage.dart';
import 'package:bookworm/pages/profilepage.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
    const Homepage({super.key});

    @override
        State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
    int selectedNavPage = 0;

    void selectPage(int value){
        setState(() {
                selectedNavPage = value;
                });
        if(value == 1){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        }
    }

    @override Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                    title: const Text("Appbar"),
                    centerTitle: true,
                    ),

                body: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                        const Text("Home Page"),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookPage())),
                            child: Container(
                                width: 200,
                                height: 80,
                                color: Colors.green,
                                child: const Text(
                                    "Go to Book",
                                    ),
                                )
                            )
                        ],
                        ),
                    ),

                bottomNavigationBar: BottomNavigationBar(
                        currentIndex: selectedNavPage,
                        onTap: selectPage,
                        items: const [
                        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
                        ]
                        ),
                );
    }
}
