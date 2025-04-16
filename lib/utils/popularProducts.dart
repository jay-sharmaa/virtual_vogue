import 'package:flutter/material.dart';
import 'package:virtualvogue/utils/itemcards.dart';

Widget PopularProducts(BuildContext context) {
  return Container(
    color: const Color(0xFFF0EDE6),
    child: ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        faceWashAdWidget(
          title: "Men's organic face wash",
          subtitle: "Different titles",
          price: "\$49",
          context: context,
          name: 'assets/shirt1.png'
        ),
        SizedBox(
          height: 32,
        ),
        faceWashAdWidget(
          title: "Radiant Face Elixir",
          subtitle: "Glow up kit",
          price: "\$59",
          context: context,
          name: 'assets/shirt2.png'
        ),
        SizedBox(
          height: 32,
        ),
        faceWashAdWidget(
          title: "Hydrating Mist",
          subtitle: "Soothing hydration",
          price: "\$39",
          context: context,
          name: 'assets/tshirt1.png'
        ),
      ],
    ),
  );
}
