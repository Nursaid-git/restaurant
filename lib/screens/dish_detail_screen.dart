import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/models/dish.dart';
import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/screens/cart_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

class DishDetailScreen extends StatefulWidget {
  final Dish dish;
  const DishDetailScreen({super.key, required this.dish});

  @override
  State<DishDetailScreen> createState() => _DishDetailScreenState();
}

class _DishDetailScreenState extends State<DishDetailScreen> {
  final Set<String> _selectedOptionIds = {};

  double get _currentPrice {
    final extra = widget.dish.customizations
        .where((o) => _selectedOptionIds.contains(o.id))
        .fold(0.0, (sum, o) => sum + o.extraPrice);
    return widget.dish.price + extra;
  }

  void _addToCart() {
    final selectedOptions = widget.dish.customizations
        .where((o) => _selectedOptionIds.contains(o.id))
        .toList();

    context.read<CartProvider>().addItem(widget.dish, selectedOptions);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.accentDark,
        content: Text('«${widget.dish.name}» добавлено в корзину'),
        duration: const Duration(seconds: 1),
      ),
    );
    Navigator.of(context).pop();
  }

  int _currentIndex = 0;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final dish = widget.dish;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildImageHeader(context, dish),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              dish.name,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                            ),
                          ),
                          Text(
                            '\$${_currentPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Row(
                        children: [
                          _tag(Icons.scale_outlined, dish.weight),
                          const SizedBox(width: 8),
                          _tag(Icons.local_fire_department_outlined, '${dish.calories} ккал'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                      child: Text(
                        dish.description,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.5,
                          height: 1.5,
                        ),
                      ),
                    ),
                    if (dish.customizations.isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                        child: Text(
                          'ОПЦИИ КАСТОМИЗАЦИИ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ...dish.customizations.map(_buildOptionTile),
                    ],
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: ElevatedButton.icon(
            onPressed: _addToCart,
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Добавить в корзину — \$${_currentPrice.toStringAsFixed(2)}'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
          ),
        ),
      ),
    );
  }

  Widget _buildImageHeader(BuildContext context, Dish dish) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1.05,
          child: Image.network(
            dish.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: AppColors.chipBg,
              child: const Icon(Icons.restaurant, size: 48, color: AppColors.textSecondary),
            ),
          ),
        ),
        Positioned(
          top: 12,
          left: 12,
          child: _circleButton(
            icon: Icons.close,
            onTap: () => Navigator.of(context).pop(),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: _circleButton(
            icon: Icons.shopping_bag_outlined,
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CartScreen(onAddDish: () => _goToTab(0)))),
          ),
        ),
      ],
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.45),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _tag(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildOptionTile(CustomizationOption option) {
    final selected = _selectedOptionIds.contains(option.id);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            if (selected) {
              _selectedOptionIds.remove(option.id);
            } else {
              _selectedOptionIds.add(option.id);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    if (option.subtitle != null)
                      Text(
                        option.subtitle!,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                  ],
                ),
              ),
              Checkbox(
                value: selected,
                onChanged: (v) {
                  setState(() {
                    if (v == true) {
                      _selectedOptionIds.add(option.id);
                    } else {
                      _selectedOptionIds.remove(option.id);
                    }
                  });
                },
                activeColor: AppColors.accent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
