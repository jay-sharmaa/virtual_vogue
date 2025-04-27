import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeDecor extends StatefulWidget {
  const HomeDecor({super.key});

  @override
  _HomeDecorState createState() => _HomeDecorState();
}

class _HomeDecorState extends State<HomeDecor> {
  String selectedCategory = "All products";

  List<Widget> getProductWidgets() {
    switch (selectedCategory) {
      case "Popular":
        return [
          _buildProductCard("Slim Fit Linen Shirt", "\$29", 'assets/shirt1.png'),
          const SizedBox(width: 16),
          _buildProductCard("Tailored Cotton Shirt", "\$69", 'assets/shirt2.png'),
          const SizedBox(width: 16),
          _buildProductCard("Relaxed Fit Knitwear", "\$79", 'assets/black_checks.png'),
        ];
      case "Recommended":
        return [
          _buildProductCard("Casual Button-Up Shirt", "\$35", 'assets/shirt2.png'),
          const SizedBox(width: 16),
          _buildProductCard("Relaxed Fit Knitwear", "\$79", 'assets/tshirt1.png'),
          const SizedBox(width: 16),
          _buildProductCard("Casual Button-Up Shirt", "\$79", 'assets/black_checks.png'),
        ];
      default:
        return [
          const SizedBox(width: 16),
          _buildProductCard("Relaxed Fit Knitwear", "\$79", 'assets/black_checks.png'),
          const SizedBox(width: 16),
          _buildProductCard("Everyday Work Shirt", "\$59", 'assets/shirt2.png'),
          const SizedBox(width: 16),
          _buildProductCard("Breathable Summer Tee", "\$39", 'assets/tshirt1.png'),
        ];
    }
  }

  Widget buildCategorySelector() {
    final categories = ["All products", "Popular", "Recommended"];

    return RotatedBox(
      quarterTurns: -3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: categories.map((category) {
            return GestureDetector(
              onTap: () {
                print("click");
                setState(() {
                  selectedCategory = category;
                });
              },
              child: Row(
                children: [
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (category != categories.last)
                    const Text(
                      " ◆ ",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0EDE6),
      child: Row(
        children: [
          buildCategorySelector(),
          Expanded(
            child: SizedBox(
              height: 500,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 16),
                children: getProductWidgets(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                  "Comfortable fit with timeless appeal.",
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
