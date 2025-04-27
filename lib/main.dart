import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtualvogue/aiChatBot.dart';
import 'package:virtualvogue/navigationpages/cart_page.dart';
import 'package:virtualvogue/pages/explorePage.dart';
import 'package:virtualvogue/pages/homePage.dart';
import 'package:virtualvogue/pages/settingPage.dart';
import 'package:camera/camera.dart';

// Global navigator key to access context from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Virtual Vogue',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey, // Add navigator key
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

int cartItemCount = 0;

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
        HomePage(onAddToCart: incrementCartCount),
        ExplorePage(),
        SettingsPage(),
      ];
    });
  }

  void incrementCartCount() {
    setState(() {
      cartItemCount++;
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
        title: Text(
          'Virtual Vogue',
          style: GoogleFonts.bodoniModa(fontSize: 28, height: 1.5),
        ),
        backgroundColor: const Color(0xFFF0EDE9),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return CartPage();
                        },
                      ),
                    );
                  },
                  child: const Text(
                    "Cart",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: Text(
                      cartItemCount.toString().padLeft(2, '0'),
                      style: GoogleFonts.bodoniModa(
                        fontSize: 24,
                        height: 1.5,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.black,
                  ),
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return ClothingSuggestionForm();
                            },
                          ),
                        );
                      },
                      child: Text(
                        'AI help',
                        style: GoogleFonts.bodoniModa(
                          fontSize: 12,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
            ),
          ),
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
      selectedItemColor: Colors.black,
      currentIndex: currentIndex,
      onTap: onTabSelected,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }
}
