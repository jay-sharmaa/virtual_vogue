import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtualvogue/navigationpages/tryPage.dart';
import 'package:virtualvogue/utils/homeScroolDecor.dart';
import 'package:virtualvogue/utils/itemcards.dart';
import 'package:virtualvogue/utils/popularProducts.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HomeDecor(),
        Container(
          color: const Color(0xFFF0EDE6),
          child: Text(
            "Popular products",
            style: GoogleFonts.bodoniModa(
                  fontSize: 24,
                  height: 1.5,
                ),
          ),
        ),
        PopularProducts(context)
      ],
    );
  }
}
