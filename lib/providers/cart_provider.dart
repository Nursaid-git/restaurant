import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/cart_item.dart';
import '../models/dish.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];
  String orderComment = '';
  bool _isSending = false;

  static const double serviceFeeRate = 0.10;

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isSending => _isSending;

  int get maxPreparationMinutes {
    if (_items.isEmpty) return 0;
    return _items
        .map((i) => i.estimatedPreparationMinutes)
        .reduce((a, b) => a > b ? a : b);
  }

  String get estimatedWaitTime {
    final max = maxPreparationMinutes;
    if (max == 0) return '—';
    return '${max + 10}–${max + 15} мин';
  }

  int get totalCount => _items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get serviceFee => subtotal * serviceFeeRate;
  double get total => subtotal + serviceFee;
  bool get isEmpty => _items.isEmpty;

  String buildRowId(Dish dish, List<CustomizationOption> options) {
    final optionIds = options.map((o) => o.id).toList()..sort();
    return '${dish.id}_${optionIds.join('-')}';
  }

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

  void setComment(String value) {
    orderComment = value;
  }

  // Метод отправки заказа в Supabase
  Future<bool> sendOrderToSupabase(String restaurantId, String tableName) async {
    if (_items.isEmpty) return false;

    _isSending = true;
    notifyListeners();

    try {
      final supabase = Supabase.instance.client;

      // 1. Создаем основной заказ
      final orderResponse = await supabase.from('orders').insert({
        'restaurant_id': restaurantId,
        'table_name': tableName,
        'total_price': total,
        'comment': orderComment,
      }).select().single();

      final orderId = orderResponse['id'];

      // 2. Создаем позиции заказа
      final List<Map<String, dynamic>> itemsToInsert = _items.map((item) => {
        'order_id': orderId,
        'dish_id': item.dish.id,
        'dish_name': item.dish.name,
        'quantity': item.quantity,
        'price_at_order': item.totalPrice,
        'options': item.optionsSummary,
      }).toList();

      await supabase.from('order_items').insert(itemsToInsert);

      // 3. Очищаем корзину после успеха
      _items.clear();
      orderComment = '';
      return true;
    } catch (e) {
      debugPrint('Error placing order: $e');
      return false;
    } finally {
      _isSending = false;
      notifyListeners();
    }
  }
}
