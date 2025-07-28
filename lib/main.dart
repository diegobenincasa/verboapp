import 'package:flutter/material.dart';
import 'screens/youtube_screen.dart';
import 'screens/calendar_screen.dart';
import 'package:google_fonts/google_fonts.dart';


void main() => runApp(VerboApp());

class VerboApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VerboApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    YouTubeScreen(),
    CalendarScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Center( // 👈 Force centering
          child: Image.asset(
            'assets/images/logo.webp',
            height: 72,
          ),
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: 'Vídeos'),
          BottomNavigationBarItem(
              icon: Icon(Icons.event), label: 'Agenda'),
        ],
      ),
    );
  }
}
