import 'package:flutter/material.dart';
import 'package:virtualvogue/utils/itemcards.dart';

Widget PopularProducts(BuildContext context, VoidCallback onAddToCart) {
  return Container(
    color: const Color(0xFFF0EDE6),
    child: ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        faceWashAdWidget(
          title: "Men's Organic T-Shirt",
          subtitle: "Breathable cotton for all-day comfort",
          price: "\$49",
          context: context,
          name: 'assets/shirt1.png',
          onAddToCart: onAddToCart,
        ),
        SizedBox(height: 32),
        faceWashAdWidget(
          title: "Slim Fit Jeans",
          subtitle: "Stylish and Comfortable",
          price: "\$59",
          context: context,
          name: 'assets/mens_jeans.png',
          onAddToCart: onAddToCart,
        ),
        SizedBox(height: 32),
        faceWashAdWidget(
          title: "Casual Jacket",
          subtitle: "Lightweight and Trendy",
          price: "\$39",
          context: context,
          name: 'assets/mens_jacket.png',
          onAddToCart: onAddToCart,
        ),
      ],
    ),
  );
}
