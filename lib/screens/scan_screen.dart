import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restaurant/screens/restaurant_selection_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Рамка сканера будет занимать 70% ширины экрана, но не более 300px
    final scannerSize = (screenWidth * 0.7).clamp(200.0, 300.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            left: 20,
            right: 20,
            child: const Center(
              child: Text(
                'Сканировать QR-код',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: scannerSize,
              height: scannerSize,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB95C1D),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB95C1D),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => const RestaurantSelectionScreen())
                );
              },
              child: const Text(
                'Начать выбор',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
