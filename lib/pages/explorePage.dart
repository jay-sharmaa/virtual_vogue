import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                SearchBarWidget(),
              ],
            ),
            const SizedBox(height: 16),

            // Tabs
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  TabChip(label: "Men", selected: true),
                  TabChip(label: "Women"),
                  TabChip(label: "Children"),
                  TabChip(label: "New offers"),
                  TabChip(label: "Popular"),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // New Arrivals
            const SectionHeader(title: "New arrival"),
            const SizedBox(height: 12),
            ProductRow(
              products: const [
                ProductData(name: "Nike ACG", price: "\$250.50", color: Colors.purple),
                ProductData(name: "Solo Swoosh", price: "\$150.20", color: Colors.blue),
              ],
            ),
            const SizedBox(height: 24),

            // Popular
            const SectionHeader(title: "Popular"),
            const SizedBox(height: 12),
            ProductRow(
              products: const [
                ProductData(name: "Men's Fleece Pullover", price: "\$180.00", color: Colors.pink),
                ProductData(name: "Nike Therma-FIT ADV", price: "\$185.00", color: Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TabChip extends StatelessWidget {
  final String label;
  final bool selected;

  const TabChip({super.key, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.black : Colors.grey[600],
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Text(
          "View all",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class ProductRow extends StatelessWidget {
  final List<ProductData> products;

  const ProductRow({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: products.map((product) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ProductCard(data: product),
          ),
        );
      }).toList(),
    );
  }
}

class ProductData {
  final String name;
  final String price;
  final Color color;

  const ProductData({
    required this.name,
    required this.price,
    required this.color,
  });
}

class ProductCard extends StatelessWidget {
  final ProductData data;

  const ProductCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product Image Placeholder
        Container(
          height: 140,
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.topRight,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.favorite_border),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Text(
          data.price,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const SearchBarWidget({super.key, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
