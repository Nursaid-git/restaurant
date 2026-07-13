import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restaurant/screens/restaurant_selection_screen.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фоновая картинка
          Image.network(
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
          ),
          // Эффект размытия
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),

          // Заголовок
          const Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Center(
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

          // Рамка сканера
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB95C1D),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Stack(
                children: [
                   // Можно добавить анимацию линии сканирования позже
                ],
              ),
            ),
          ),

          // Кнопка внизу экрана для перехода
          Positioned(
            bottom: 50,
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
                // После "сканирования" переходим к выбору ресторана
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
