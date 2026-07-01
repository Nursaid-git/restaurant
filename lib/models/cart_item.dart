import 'dish.dart';

class CartItem {
  final String id; // уникальный id строки корзины (блюдо + набор опций)
  final Dish dish;
  final List<CustomizationOption> selectedOptions;
  int quantity;

  CartItem({
    required this.id,
    required this.dish,
    required this.selectedOptions,
    this.quantity = 1,
  });

  double get unitPrice =>
      dish.price + selectedOptions.fold(0.0, (sum, o) => sum + o.extraPrice);

  double get totalPrice => unitPrice * quantity;

  String get optionsSummary {
    if (selectedOptions.isEmpty) return '';
    return selectedOptions.map((o) => o.title).join(', ');
  }
}
