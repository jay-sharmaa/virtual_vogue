import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtualvogue/utils/cart_page_product.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, String>> cartItems = [
    {"title": "Slim Fit Linen Shirt", "price": "\$29", "path": "assets/shirt1.png"},
    {"title": "Tailored Cotton Shirt", "price": "\$69", "path": "assets/shirt2.png"},
    {"title": "Relaxed Fit Knitwear", "price": "\$79", "path": "assets/black_checks.png"},
    {"title": "Breathable Summer Tee", "price": "\$39", "path": "assets/tshirt1.png"},
  ];

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: GoogleFonts.bodoniModa(fontSize: 28, height: 1.5),
        ),
        backgroundColor: const Color(0xFFF0EDE9),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                itemCount: cartItems.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constraints.maxWidth > 600 ? 3 : 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3 / 4.2,
                ),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return GestureDetector(
                    onDoubleTap: () => removeItem(index),
                    child: CartProductCard(
                      title: item["title"]!,
                      price: item["price"]!,
                      imagePath: item["path"]!,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
