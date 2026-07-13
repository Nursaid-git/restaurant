import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/screens/cart_screen.dart';
import 'package:restaurant/models/dish.dart';
import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/theme/app_theme.dart';
import 'package:restaurant/screens/dish_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _selectedCategory = 'Все';
  bool _isSearching = false;
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Dish> _getFilteredDishes(List<Dish> allDishes) {
    List<Dish> filtered = allDishes;
    
    if (_isSearching && _searchQuery.trim().isNotEmpty) {
      final query = _searchQuery.trim().toLowerCase();
      filtered = filtered.where((d) => d.name.toLowerCase().contains(query)).toList();
    } else if (_selectedCategory != 'Все') {
      filtered = filtered.where((d) => d.category == _selectedCategory).toList();
    }
    
    return filtered;
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().totalCount;
    final resProvider = context.watch<RestaurantProvider>();
    final restaurantName = resProvider.selectedRestaurant?.name ?? "Меню";
    final allDishes = resProvider.dishes;
    final filteredDishes = _getFilteredDishes(allDishes);

    final categories = ['Все', ...allDishes.map((d) => d.category).toSet().toList()];

    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = 2;
    double childAspectRatio = 0.64; 

    if (screenWidth > 900) {
      crossAxisCount = 4;
      childAspectRatio = 0.75;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
      childAspectRatio = 0.70;
    } else if (screenWidth < 380) {
      // Еще выше для самых узких экранов
      childAspectRatio = 0.54; 
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CartScreen(onAddDish: () {})));
        },
        backgroundColor: AppColors.accent,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, color: Colors.white),
                Text('Корзина',
                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600))
              ],
            ),
            if (cartCount > 0)
              Positioned(
                top: -8,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
                    ],
                  ),
                  constraints: const BoxConstraints(minWidth: 22, minHeight: 22),
                  child: Text(
                    '$cartCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      appBar: AppBar(
        title: _isSearching
            ? TextField(
          controller: _searchController,
          autofocus: true,
          onChanged: (value) => setState(() => _searchQuery = value),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          decoration: const InputDecoration(
            hintText: 'Поиск блюда...',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            border: InputBorder.none,
          ),
        )
            : Align(
            alignment: Alignment.topLeft,
            child: Text(restaurantName, style: const TextStyle(color: AppColors.accent))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: _toggleSearch,
              child: Icon(_isSearching ? Icons.close : Icons.search),
            ),
          ),
        ],
      ),
      body: resProvider.isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
        : Column(
        children: [
          if (!_isSearching) _buildCategoryChips(categories),
          Expanded(
            child: filteredDishes.isEmpty
                ? const Center(
              child: Text(
                'Блюда не найдены',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            )
                : GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              itemCount: filteredDishes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: childAspectRatio,
              ),
              itemBuilder: (context, index) {
                final dish = filteredDishes[index];
                return _DishCard(dish: dish);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(List<String> categories) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
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
                        alignment: Alignment.center,
                        child: const Icon(Icons.broken_image_outlined, color: AppColors.textSecondary, size: 30),
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
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
              child: Text(
                dish.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 4, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '\$${dish.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
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
