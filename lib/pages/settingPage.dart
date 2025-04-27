import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:virtualvogue/navigationpages/helpCenter.dart';
import 'package:virtualvogue/navigationpages/newClothPage.dart';
import 'package:virtualvogue/navigationpages/simple_render.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EDE6),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: const Color(0xFF5C6273),
              width: double.infinity,
              height: 120,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 110,
                    top: 10,
                    child: Container(
                      width: 200,
                      height: 200,
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
                ],
              ),
            ),

            const SizedBox(height: 80),

            // Menu items
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SequentialTextPage(),
                  ),
                );
              },
              child: _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: "Try Someone's cloth",
                subtitle: "Scan and try the attire you like",
              ),
            ),
            const Divider(height: 1),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GeminiChatPage(),
                  ),
                );
              },
              child: _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: "Help Center",
                subtitle: "Help regarding your recent purchases",
              ),
            ),

            const Divider(height: 1),
            _buildMenuItem(
              icon: Icons.qr_code_scanner_outlined,
              title: "Scan for coupon",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QrScannerPage()),
                );
                if (result != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Scanned coupon: $result')),
                  );
                }
              },
            ),
            const Divider(height: 1),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleRender(),
                  ),
                );
              },
              child: _buildMenuItem(
                icon: Icons.person_outline_rounded,
                title: "Check Our 3D render",
                subtitle: "Prepare it first!",
              ),
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
                      "APP VERSION 1.00",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
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
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 26, color: Colors.grey),
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
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
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

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  String? scannedText;

  final MobileScannerController controller = MobileScannerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture barcode) {
    final String? code = barcode.barcodes.first.rawValue;

    if (code != null && scannedText == null) {
      setState(() {
        scannedText = code;
      });

      controller.stop();
      Navigator.pop(context, code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(controller: controller, onDetect: _onDetect),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child:
                  scannedText != null
                      ? Text('Scanned: $scannedText')
                      : const Text('Scan a QR code'),
            ),
          ),
        ],
      ),
    );
  }
}
