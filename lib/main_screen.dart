import 'package:flutter/material.dart';
import 'features/home/presentation/pages/home_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(), // Functional HomePage
    Scaffold(
      appBar: AppBar(title: Text('Tab 2')),
      body: Center(child: Text('Tab 2 Placeholder')),
    ),
    Scaffold(
      appBar: AppBar(title: Text('Tab 3')),
      body: Center(child: Text('Tab 3 Placeholder')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.tab), label: 'Tab 2'),
          BottomNavigationBarItem(icon: Icon(Icons.tab), label: 'Tab 3'),
        ],
      ),
    );
  }
}
