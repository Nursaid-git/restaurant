import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:restaurant/screens/welcome_screen.dart';

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
            // Если картинка не загрузится, покажем серый фон
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
          ),
          // Эффект размытия
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              color: Colors.black.withOpacity(0.6), // Легкое затемнение
            ),
          ),

          // Верхняя панель (Кнопка назад и Заголовок)
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      // Логика возврата назад (пока мы на первом экране, она просто для визуала)
                    },
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Сканировать QR-код',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Рамка сканера по центру (упрощенный вариант рамки)
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFFB95C1D), // Оранжевый цвет из ТЗ
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(24),
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
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Переходим на экран приветствия
                Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
              child: const Text(
                'Открыть меню',
                style: TextStyle(
                  fontSize: 16,
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