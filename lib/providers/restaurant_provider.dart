import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/dish.dart';

class RestaurantInfo {
  final String id; // UUID из Supabase
  final String name;
  final String type; // 'restaurant', 'cafe', 'fastfood'

  RestaurantInfo({required this.id, required this.name, required this.type});
}

class TableInfo {
  final String id;
  final String number;
  final int capacity;

  TableInfo({required this.id, required this.number, required this.capacity});
}

class RestaurantProvider with ChangeNotifier {
  RestaurantInfo? _selectedRestaurant;
  TableInfo? _selectedTable;
  List<Dish> _dishes = [];
  List<TableInfo> _tables = [];
  bool _isLoading = false;
  bool _isLoadingTables = false;

  RestaurantInfo? get selectedRestaurant => _selectedRestaurant;
  TableInfo? get selectedTable => _selectedTable;
  List<Dish> get dishes => _dishes;
  List<TableInfo> get tables => _tables;
  bool get isLoading => _isLoading;
  bool get isLoadingTables => _isLoadingTables;

  void setRestaurant(RestaurantInfo restaurant) {
    _selectedRestaurant = restaurant;
    _selectedTable = null; 
    _tables = [];
    fetchDishes();
    fetchTables();
    notifyListeners();
  }

  void setTable(TableInfo table) {
    _selectedTable = table;
    notifyListeners();
  }

  // Новый метод для установки данных через скан QR-кода
  Future<bool> setByTableId(String tableId) async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Получаем данные стола и ресторана одним запросом
      final response = await Supabase.instance.client
          .from('tables')
          .select('*, restaurants(*)')
          .eq('id', tableId)
          .single();

      final resData = response['restaurants'];
      
      _selectedRestaurant = RestaurantInfo(
        id: resData['id'],
        name: resData['name'],
        type: resData['type'],
      );

      _selectedTable = TableInfo(
        id: response['id'],
        number: response['table_number'],
        capacity: response['capacity'] ?? 2,
      );

      // 2. Загружаем меню этого ресторана
      await fetchDishes();
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error setting by table ID: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> fetchTables() async {
    if (_selectedRestaurant == null) return;

    _isLoadingTables = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('tables')
          .select()
          .eq('restaurant_id', _selectedRestaurant!.id)
          .eq('is_available', true)
          .order('table_number', ascending: true);

      _tables = (response as List).map((data) => TableInfo(
        id: data['id'],
        number: data['table_number'],
        capacity: data['capacity'] ?? 2,
      )).toList();
    } catch (e) {
      debugPrint('Error fetching tables: $e');
      _tables = [];
    } finally {
      _isLoadingTables = false;
      notifyListeners();
    }
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
