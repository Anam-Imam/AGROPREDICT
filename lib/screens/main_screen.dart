import 'package:flutter/material.dart';

import 'bottom_screens/detection_screen.dart';
import 'bottom_screens/farmer_screen.dart';
import 'bottom_screens/market_price_screen.dart';
import 'bottom_screens/weather_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // final screens = [
    //   DetectionScreen(),
    //   FarmerScreen(),
    //   MarketPricesScreen(),
    //   WeatherScreen(),
    // ];
    final screens = [
  DetectionScreen(),
  MarketPricesScreen(),
  WeatherScreen(),
];

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: Text(
          'AgroPredict'.toUpperCase(),
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: "Detection",
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.event_note),
          //   label: "Planning",
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: "Mandi",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wb_sunny_outlined),
            label: "Weather",
          ),
        ],
      ),
    );
  }
}
