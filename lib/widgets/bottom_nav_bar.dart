import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;

    final items = [
      _NavItemData(icon: Icons.restaurant_menu_outlined, label: 'Меню'),
      _NavItemData(icon: Icons.receipt_long_outlined, label: 'Заказы'),
      _NavItemData(icon: Icons.shopping_bag_outlined, label: 'Корзина', badge: cartCount),
      _NavItemData(icon: Icons.person_outline, label: 'Профиль'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.card,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (i) {
            final selected = i == currentIndex;
            final item = items[i];
            final color = selected ? AppColors.accent : AppColors.textSecondary;
            return InkWell(
              onTap: () => onTap(i),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(item.icon, color: color, size: 24),
                        if (item.badge != null && item.badge! > 0)
                          Positioned(
                            right: -6,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              child: Text(
                                '${item.badge}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.label,
                      style: TextStyle(
                        color: color,
                        fontSize: 11,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItemData {
  final IconData icon;
  final String label;
  final int? badge;
  _NavItemData({required this.icon, required this.label, this.badge});
}
