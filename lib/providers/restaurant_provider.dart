import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dish.dart';

class RestaurantInfo {
  final String id; // UUID из Supabase
  final String name;
  final String type; // 'restaurant', 'cafe', 'fastfood'

  RestaurantInfo({required this.id, required this.name, required this.type});
}

class RestaurantProvider with ChangeNotifier {
  RestaurantInfo? _selectedRestaurant;
  String? _selectedTable;
  List<Dish> _dishes = [];
  bool _isLoading = false;

  RestaurantInfo? get selectedRestaurant => _selectedRestaurant;
  String? get selectedTable => _selectedTable;
  List<Dish> get dishes => _dishes;
  bool get isLoading => _isLoading;

  void setRestaurant(RestaurantInfo restaurant, String table) {
    _selectedRestaurant = restaurant;
    _selectedTable = table;
    fetchDishes(); // Загружаем блюда при выборе ресторана
    notifyListeners();
  }

  Future<void> fetchDishes() async {
    if (_selectedRestaurant == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('dishes')
          .select('*, dish_customizations(*)')
          .eq('restaurant_id', _selectedRestaurant!.id);

      _dishes = (response as List).map((data) => Dish.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching dishes: $e');
      _dishes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
