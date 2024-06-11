import 'dart:async';

import 'package:bookworm/pages/mainpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Image logo = Image.asset("lib/assets/logo.png");

  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Mainpage()
        )
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logo,
                Container(
                  alignment: Alignment.bottomRight,
                  child: const Text(
                    "1.0.0",
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.black
                    )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
