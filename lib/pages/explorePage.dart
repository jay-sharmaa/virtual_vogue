import 'package:flutter/material.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedIndex = 0;
  String searchQuery = '';

  final List<String> tabs = [
    "Men",
    "Women",
    "New offers",
    "Popular",
  ];

  final Map<String, List<ProductData>> categorizedProducts = {
    "Men": [
      ProductData(name: "Men's Hoodie", price: "\$60.00", path: 'assets/mens_hoodie.png'),
      ProductData(
        name: "Men's Shirt",
        price: "\$45.00",
        path: 'assets/shirt1.png'
      ),
      ProductData(
        name: "Men's T-Shirt",
        price: "\$25.00",
        path: 'assets/mens_tshirt.png'
      ),
      ProductData(name: "Men's Jeans", price: "\$70.00", path: 'assets/mens_jeans.png'),
      ProductData(name: "Men's Jacket", price: "\$90.00", path: 'assets/mens_jacket.png'),
      ProductData(
        name: "Men's T-shirt",
        price: "\$100.00",
        path: 'assets/tshirt1.png'
      ),
    ],
    "Women": [
      ProductData(
        name: "Women's White Shirt",
        price: "\$40.00",
        path: 'assets/womens_white_shirt.png'
      ),
      ProductData(
        name: "Women's Purple Shirt",
        price: "\$70.00",
        path: 'assets/womens_purple_shirt.png'
      ),
      ProductData(
        name: "Women's Jeans",
        price: "\$55.00",
        path: 'assets/womens_jeans.png'
      ),
      ProductData(
        name: "Women's Yellow Jacket",
        price: "\$75.00",
        path: 'assets/womens_yellow_jacket.png'
      ),
      ProductData(
        name: "Women's Jacket",
        price: "\$100.00",
        path: 'assets/womens_black_jacket.png'
      ),
      ProductData(name: "Women's Hoodie", price: "\$60.00", path: 'assets/womens_hoodie.png'),
    ],
    "New offers": [
      ProductData(
        name: "Men's Shirt",
        price: "\$45.00",
        path: 'assets/shirt1.png'
      ),
      ProductData(
        name: "Women's Jacket",
        price: "\$100.00",
        path: 'assets/womens_black_jacket.png'
      ),
      ProductData(
        name: "Men's T-shirt",
        price: "\$100.00",
        path: 'assets/tshirt1.png'
      ),
      ProductData(
        name: "Women's Jeans",
        price: "\$55.00",
        path: 'assets/womens_jeans.png'
      ),
      ProductData(
        name: "Women's White Shirt",
        price: "\$40.00",
        path: 'assets/womens_white_shirt.png'
      ),
    ],
    "Popular": [
      ProductData(
        name: "Women's White Shirt",
        price: "\$40.00",
        path: 'assets/womens_white_shirt.png'
      ),
      ProductData(
        name: "Women's Yellow Jacket",
        price: "\$75.00",
        path: 'assets/womens_yellow_jacket.png'
      ),
      ProductData(name: "Men's Jeans", price: "\$70.00", path: 'assets/mens_jeans.png'),
      ProductData(name: "Men's Jacket", price: "\$90.00", path: 'assets/mens_jacket.png'),
      ProductData(
        name: "Men's Shirt",
        price: "\$45.00",
        path: 'assets/shirt1.png'
      ),
      ProductData(name: "Women's Hoodie", price: "\$60.00", path: 'assets/womens_hoodie.png'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final selectedTab = tabs[selectedIndex];

    final List<ProductData> products =
        categorizedProducts[selectedTab]!
            .where(
              (product) => product.name.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
            )
            .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Search bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SearchBarWidget(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tabs
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: TabChip(
                      label: tabs[index],
                      selected: selectedIndex == index,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            SectionHeader(title: selectedTab),
            const SizedBox(height: 12),

            products.isEmpty
                ? const Center(child: Text("No results found."))
                : ProductRow(products: products),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? Colors.black : Colors.grey),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            color: selected ? Colors.white : Colors.black,
          ),
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
    return Wrap(
      spacing: 12,
      runSpacing: 16,
      children:
          products.map((product) {
            return SizedBox(
              width: MediaQuery.of(context).size.width / 2 - 24,
              child: ProductCard(data: product),
            );
          }).toList(),
    );
  }
}

class ProductData {
  final String name;
  final String price;
  final String path;

  const ProductData({
    required this.name,
    required this.price,
    required this.path,
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
        Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.topRight,
          child: Image.asset(data.path)
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
          hintText: 'Search clothes...',
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
