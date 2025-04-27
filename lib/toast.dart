// toast_service.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart' show navigatorKey;

class ToastService {
  // Singleton pattern
  static final ToastService _instance = ToastService._internal();
  factory ToastService() => _instance;
  ToastService._internal();
  
  Timer? _scheduledToastTimer;
  
  // Show toast notification using a simpler ScaffoldMessenger approach
  void showGlobalToast(String message, {Duration duration = const Duration(seconds: 3)}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    
    // Use ScaffoldMessenger for reliable toast-like notifications
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.bodoniModa(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }
  
  // Schedule a toast notification to show after a delay
  void scheduleToast(String message, Duration delay) {
    // Cancel any previously scheduled toast
    _scheduledToastTimer?.cancel();
    
    // Schedule new toast
    _scheduledToastTimer = Timer(delay, () {
      showGlobalToast(message);
    });
  }
  
  // Cancel scheduled toast if needed
  void cancelScheduledToast() {
    _scheduledToastTimer?.cancel();
    _scheduledToastTimer = null;
  }
}