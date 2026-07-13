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

  /// Примерное время приготовления этой позиции с учётом количества:
  /// каждая дополнительная порция чуть увеличивает время (кухня всё ещё
  /// готовит параллельно с другими блюдами, но несколько порций одного
  /// блюда занимают больше места на плите/в духовке).
  static const int extraMinutesPerExtraPortion = 3;

  int get estimatedPreparationMinutes =>
      dish.preparationMinutes + (quantity - 1) * extraMinutesPerExtraPortion;

  String get optionsSummary {
    if (selectedOptions.isEmpty) return '';
    return selectedOptions.map((o) => o.title).join(', ');
  }
}
