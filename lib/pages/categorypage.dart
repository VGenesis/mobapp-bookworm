import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
              appBar: AppBar(
                  title: const Text("Appbar"),
                  centerTitle: true,
                  ),
              body: const Column(),

              bottomNavigationBar: BottomNavigationBar(
                  items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                  ]
                  ),
              );
  }
}
