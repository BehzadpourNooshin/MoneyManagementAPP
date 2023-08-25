import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:moneymgtapp/constant.dart';
import 'package:moneymgtapp/screens/homescreen.dart';
import 'package:moneymgtapp/screens/infoscreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  Widget body = const HomeScreen();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        inactiveColor: kBlackColor,
        icons: const [Icons.home, Icons.info],
        activeIndex: currentIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.smoothEdge,
        onTap: (index) {
          (index == 0)
              ? (body = const HomeScreen()) //HomeScreen())
              : (body = const InfoScreen());

          setState(() {
            index = currentIndex;
          });
        },
      ),
      body: body,
    );
  }
}
