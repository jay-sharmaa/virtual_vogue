import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFF5C6273),
              width: double.infinity,
              height: 120,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 20,
                    top: 30,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        size: 60,
                        color: Color(0xFF5C6273),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    left: 130,
                    bottom: -25,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4F79),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Text(
                        'LOG IN/SIGN UP',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Menu items
            _buildMenuItem(
              icon: Icons.inventory_2_outlined,
              title: "Orders",
              subtitle: "Check your order status",
            ),
            const Divider(height: 1),
            _buildMenuItem(
              icon: Icons.person_outline_rounded,
              title: "Help Center",
              subtitle: "Help regarding your recent purchases",
            ),
            const Divider(height: 1),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: "Wishlist",
              subtitle: "Your most loved styles",
            ),
            const Divider(height: 1),
            _buildMenuItem(
              icon: Icons.qr_code_scanner_outlined,
              title: "Scan for coupon",
            ),
            
            const Divider(height: 1),
            
            // Footer links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(top: 20),
                children: [
                  _buildFooterLink("FAQs"),
                  _buildFooterLink("ABOUT US"),
                  _buildFooterLink("TERMS OF USE"),
                  _buildFooterLink("PRIVACY POLICY"),
                  _buildFooterLink("GRIEVANCE REDRESSAL"),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      "APP VERSION 4.2503.21",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(
            icon,
            size: 26,
            color: Colors.grey,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF5C6273),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.grey,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}