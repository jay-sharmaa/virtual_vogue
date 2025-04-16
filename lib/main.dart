import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtualvogue/pages/explorePage.dart';
import 'package:virtualvogue/pages/homePage.dart';
import 'package:virtualvogue/pages/settingPage.dart';
import 'package:camera/camera.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late CameraController controller;
  final PageController _pageController = PageController();
  int _selectedIndex = 0;
  late List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    setState(() {
        _pages = [
        HomePage(),
        ExplorePage(),
        SettingsPage(),
      ];
    });
  }

  void _onTabSelected(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Virtual Vogue',
        style: GoogleFonts.bodoniModa(
                  fontSize: 28,
                  height: 1.5,
                ),
        ),
        backgroundColor: const Color(0xFFF0EDE9),
        actions: [
          Row(
            children: [
            Text("Cart", style: TextStyle(
              fontWeight: FontWeight.bold
            ),),
            SizedBox(width: 6,),
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Colors.black
              ),
              child: Center(
                child: Text('04',
                        style: GoogleFonts.bodoniModa(
                          fontSize: 24,
                          height: 1.5,
                          color: Colors.white
                        ),
                      ),
                    ),
                ),
            SizedBox(width: 10,),
          ],)
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFF0EDE6),
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Explore',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}
