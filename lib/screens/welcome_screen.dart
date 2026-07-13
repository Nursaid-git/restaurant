import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final restaurant = context.watch<RestaurantProvider>().selectedRestaurant;
    final tableName = context.watch<RestaurantProvider>().selectedTable;
    final resName = restaurant?.name ?? "L'ART CULINAIRE";

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Фоновое изображение (можно менять в зависимости от типа заведения)
          Image.network(
            _getBgImage(restaurant?.type),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey.shade900),
          ),

          // Градиентное затемнение
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.9),
                ],
              ),
            ),
          ),

          // Название выбранного заведения сверху
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                resName.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3.0,
                ),
              ),
            ),
          ),

          // Карточка с текстом снизу
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Добро пожаловать!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  if (tableName != null)
                    Text(
                      'Ваш столик: $tableName',
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    _getWelcomeText(restaurant?.type),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const MenuScreen())
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Перейти к меню ',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getBgImage(String? type) {
    switch (type) {
      case 'cafe':
        return 'https://images.unsplash.com/photo-1501339847302-ac426a4a7cbb'; // Кофейня
      case 'fastfood':
        return 'https://images.unsplash.com/photo-1498837167922-ddd27525d352'; // Фастфуд
      default:
        return 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4'; // Ресторан
    }
  }

  String _getWelcomeText(String? type) {
    switch (type) {
      case 'cafe':
        return 'Начните свой день с ароматного кофе и свежей выпечки в нашей уютной атмосфере.';
      case 'fastfood':
        return 'Быстро, вкусно и всегда горячо! Выбирайте свои любимые блюда прямо сейчас.';
      default:
        return 'Откройте для себя наше сезонное меню, созданное с любовью из лучших продуктов.';
    }
  }
}
