import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/dish.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String orderComment = '';

  static const double serviceFeeRate = 0.10;

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get serviceFee => subtotal * serviceFeeRate;

  double get total => subtotal + serviceFee;

  bool get isEmpty => _items.isEmpty;

  /// Формирует уникальный id строки корзины для блюда с набором опций.
  String buildRowId(Dish dish, List<CustomizationOption> options) {
    final optionIds = options.map((o) => o.id).toList()..sort();
    return '${dish.id}_${optionIds.join('-')}';
  }

  /// Возвращает CartItem для блюда без опций (используется на карточке в меню)
  /// или null, если товара ещё нет в корзине.
  CartItem? findByDish(Dish dish, [List<CustomizationOption> options = const []]) {
    final rowId = buildRowId(dish, options);
    for (final item in _items) {
      if (item.id == rowId) return item;
    }
    return null;
  }

  void addItem(Dish dish, List<CustomizationOption> options, {int quantity = 1}) {
    final rowId = buildRowId(dish, options);

    final existingIndex = _items.indexWhere((i) => i.id == rowId);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItem(
        id: rowId,
        dish: dish,
        selectedOptions: options,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  void increment(String rowId) {
    final item = _items.firstWhere((i) => i.id == rowId);
    item.quantity++;
    notifyListeners();
  }

  void decrement(String rowId) {
    final item = _items.firstWhere((i) => i.id == rowId);
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.removeWhere((i) => i.id == rowId);
    }
    notifyListeners();
  }

  void removeItem(String rowId) {
    _items.removeWhere((i) => i.id == rowId);
    notifyListeners();
  }

  void setComment(String value) {
    orderComment = value;
  }

  void placeOrder() {
    _items.clear();
    orderComment = '';
    notifyListeners();
  }
}