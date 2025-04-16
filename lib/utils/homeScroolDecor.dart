import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget HomeDecor(){
  return Container(
      color: const Color(0xFFF0EDE6),
      child: Row(
        children: [
          RotatedBox(
            quarterTurns: -3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "All products  ◆  Facecare  ◆  Body care",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          Expanded(
            child: SizedBox(
              height: 500,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: 16,
                ),
                children: [
                  _buildProductCard("Men's organic face wash", "\$49", 'assets/shirt1.png'),
                  const SizedBox(width: 16),
                  _buildProductCard("Radiant Face Elixir", "\$59",'assets/shirt2.png'),
                  const SizedBox(width: 16),
                  _buildProductCard("Hydrating Mist", "\$39", 'assets/tshirt1.png'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
}

Widget _buildProductCard(String title, String price, String name) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(color: Colors.amber),
            child: Image.asset(name),
          ),
          Container(
            height: 100,
            color: Colors.black,
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.bodoniModa(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (price.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          price,
                          style: GoogleFonts.bodoniModa(
                          fontSize: 18,
                          height: 1.5,
                          color: Colors.white,
                        ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Beauty, make-up, skincare.",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }