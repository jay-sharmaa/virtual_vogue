import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtualvogue/main.dart';
import 'package:virtualvogue/navigationpages/tryPage.dart';

Widget faceWashAdWidget({
  required String title,
  required String subtitle,
  required String price,
  required BuildContext context,
  required String name,
  required VoidCallback onAddToCart,
}) {
  // Generate a unique hero tag based on the product title
  final heroTag = 'product-${title.hashCode}';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return ProductPage(
              heroTag: heroTag,
              title: title,
              subtitle: subtitle,
              price: price,
              onAddToCart: onAddToCart,
              name: name,
            );
          },
        ),
      );
    },
    child: Container(
      width: double.infinity,
      height: 700,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      child: Column(
        children: [
          Hero(
            tag: heroTag,
            child: Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.amber),
              child: Image.asset(name),
            ),
          ),
          Container(
            color: Colors.black,
            height: 100,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 18, 17, 17),
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    price,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ProductPage extends StatelessWidget {
  final String heroTag;
  final String title;
  final String subtitle;
  final String price;
  final String name;
  final VoidCallback onAddToCart;

  const ProductPage({
    super.key,
    required this.heroTag,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.onAddToCart,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Serif',
                  ),
                ),
                Row(
                  children: [
                    const Text('Cart', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.black,
                      child: Text(
                        "0$cartItemCount", // You can pass cartItemCount as a parameter for dynamic count
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Product image
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  name,
                  height: 380,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Title and price section
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "$title - $subtitle",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Serif',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    price,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Ratings and Reviews
            Row(
              children: const [
                Text('85 Reviews'),
                SizedBox(width: 10),
                Icon(Icons.star, color: Colors.black, size: 18),
                Icon(Icons.star, color: Colors.black, size: 18),
                Icon(Icons.star, color: Colors.black, size: 18),
                Icon(Icons.star, color: Colors.black, size: 18),
                Icon(Icons.star_border, color: Colors.black, size: 18),
                Spacer(),
                Text(
                  'See all reviews',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Description
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.8, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Text(
                "The fact that the formula of the day cream for dry skin is supported by broccoli and aloe vera shows that there is a surplus of vital nutrients for the skin. Both these ingredients have a tendency to heal dry skin as well as act as a barrier in the path of aging skin.",
                style: GoogleFonts.bodoniModa(fontSize: 18, height: 1.5),
                maxLines: 8,
                overflow: TextOverflow.clip,
              ),
            ),

            const SizedBox(height: 8), // Reduced spacing instead of Spacer()

            // Bottom buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  SizedBox(
                    width: 299,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TryPage(name: name),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Try',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 10, height: 0,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: onAddToCart,
                    child: const Icon(Icons.shop, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
