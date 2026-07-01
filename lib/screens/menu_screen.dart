import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/screens/cart_screen.dart';
import '../data/mock_data.dart';
import '../models/dish.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import 'dish_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Все';

  List<Dish> get _filteredDishes {
    if (_selectedCategory == 'Все') return kDishes;

    final matching = kDishes.where((d) => d.category == _selectedCategory).toList();
    final others = kDishes.where((d) => d.category != _selectedCategory).toList();

    return [...matching, ...others];
  }

  int _currentIndex = 0;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CartScreen(onAddDish: () => _goToTab(0))));
        },
        backgroundColor: AppColors.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_bag_outlined, color: Colors.white),
            Text('Корзина',
                style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600))
          ],
        ),
      ),
      appBar: AppBar(
        title: Align(
            alignment: Alignment.topLeft,
            child: const Text("L'Art Culinaire", style: TextStyle(color: AppColors.accent))),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.search),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryChips(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: _filteredDishes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) {
                final dish = _filteredDishes[index];
                return _DishCard(dish: dish);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: kCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = kCategories[index];
          final selected = category == _selectedCategory;
          return ChoiceChip(
            label: Text(category),
            selected: selected,
            onSelected: (_) => setState(() => _selectedCategory = category),
            selectedColor: AppColors.accent,
            backgroundColor: AppColors.chipBg,
            labelStyle: TextStyle(
              color: selected ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide.none,
            ),
            showCheckmark: false,
          );
        },
      ),
    );
  }
}

class _DishCard extends StatelessWidget {
  final Dish dish;
  const _DishCard({required this.dish});

  void _openDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DishDetailScreen(dish: dish)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openDetail(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: AspectRatio(
                    aspectRatio: 1.3,
                    child: Image.network(
                      dish.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.chipBg,
                        child: const Icon(Icons.restaurant, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          dish.rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 0),
              child: Text(
                dish.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
              child: Text(
                dish.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11.5),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${dish.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  _QuantityControl(dish: dish),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Показывает круглую кнопку "+", а после первого нажатия — степпер (- кол-во +),
/// синхронизированный с корзиной через CartProvider.
class _QuantityControl extends StatelessWidget {
  final Dish dish;
  const _QuantityControl({required this.dish});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItem = cart.findByDish(dish);
    final quantity = cartItem?.quantity ?? 0;

    if (quantity == 0) {
      return GestureDetector(
        onTap: () => cart.addItem(dish, const [], quantity: 1),
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: AppColors.accent,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 18),
        ),
      );
    }

    final rowId = cart.buildRowId(dish, const []);
    return _QuantityStepper(
      quantity: quantity,
      onDecrement: () => cart.decrement(rowId),
      onIncrement: () => cart.addItem(dish, const [], quantity: 1),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  const _QuantityStepper({
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _stepperButton(Icons.remove, onDecrement),
          SizedBox(
            width: 22,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
          _stepperButton(Icons.add, onIncrement),
        ],
      ),
    );
  }

  Widget _stepperButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(icon, size: 16, color: AppColors.accent),
      ),
    );
  }
}