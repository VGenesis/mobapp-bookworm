import 'package:flutter/material.dart';

import 'package:bookworm/pages/authorpage.dart';
import 'package:bookworm/pages/bookpage.dart';
import 'package:bookworm/pages/categorypage.dart';
import 'package:bookworm/pages/homepage.dart';
import 'package:bookworm/pages/likedpage.dart';
import 'package:bookworm/pages/searchpage.dart';
import 'package:bookworm/pages/profilepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
    const MyApp({super.key});

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: "/",
                routes: {
                    "/" : (context) => const Homepage(), 
                    "/category" : (context) => const CategoryPage(),
                    "/book" : (context) => const BookPage(), 
                    "/author" : (context) => const AuthorPage(), 
                    "/search" : (context) => const SearchPage(), 
                    "/profile" : (context) => const ProfilePage(),
                    "/liked" : (context) => const LikedPage(),
                }
                );
    }
}
