import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String imagePath;

  const CartProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(
                imagePath,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.bodoniModa(
                      fontSize: 16,
                      height: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.bodoniModa(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
