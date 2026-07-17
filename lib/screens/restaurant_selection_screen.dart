import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant/theme/app_theme.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/providers/restaurant_provider.dart';

class RestaurantSelectionScreen extends StatefulWidget {
  const RestaurantSelectionScreen({super.key});

  @override
  State<RestaurantSelectionScreen> createState() => _RestaurantSelectionScreenState();
}

class _RestaurantSelectionScreenState extends State<RestaurantSelectionScreen> {
  RestaurantInfo? selectedRes;
  TableInfo? selectedTable;
  List<RestaurantInfo> restaurants = [];
  bool isLoadingRestaurants = true;

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      final response = await Supabase.instance.client
          .from('restaurants')
          .select();
      
      setState(() {
        restaurants = (response as List).map((data) => RestaurantInfo(
          id: data['id'],
          name: data['name'],
          type: data['type'],
        )).toList();
        isLoadingRestaurants = false;
      });
    } catch (e) {
      debugPrint('Error loading restaurants: $e');
      setState(() => isLoadingRestaurants = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final resProvider = context.watch<RestaurantProvider>();
    final screenWidth = MediaQuery.of(context).size.width;
    int tableColumns = screenWidth < 360 ? 4 : 5;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Выбор заведения', style: TextStyle(color: AppColors.accent)),
        centerTitle: true,
      ),
      body: isLoadingRestaurants 
        ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
        : SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Где вы находитесь?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (restaurants.isEmpty)
              const Text('Заведения не найдены. Проверьте базу данных.'),
            ...restaurants.map((res) => _buildSelectionCard(
                  res: res,
                  isSelected: selectedRes?.id == res.id,
                  onTap: () {
                    setState(() {
                      selectedRes = res;
                      selectedTable = null;
                    });
                    context.read<RestaurantProvider>().setRestaurant(res);
                  },
                )),
            
            if (selectedRes != null) ...[
              const SizedBox(height: 32),
              const Text(
                'Выберите номер стола',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (resProvider.isLoadingTables)
                const Center(child: CircularProgressIndicator(color: AppColors.accent))
              else if (resProvider.tables.isEmpty)
                const Text('В этом заведении нет доступных столов.', style: TextStyle(color: AppColors.textSecondary))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: tableColumns,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: resProvider.tables.length,
                  itemBuilder: (context, index) {
                    final table = resProvider.tables[index];
                    final isSelected = selectedTable?.id == table.id;
                    return InkWell(
                      onTap: () => setState(() => selectedTable = table),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.accent : AppColors.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected ? AppColors.accent : AppColors.divider,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              table.number,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person, 
                                  size: 10, 
                                  color: isSelected ? Colors.white70 : AppColors.textSecondary
                                ),
                                Text(
                                  '${table.capacity}',
                                  style: TextStyle(
                                    fontSize: 10, 
                                    color: isSelected ? Colors.white70 : AppColors.textSecondary
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
            
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedRes != null && selectedTable != null)
                    ? () {
                        context.read<RestaurantProvider>().setTable(selectedTable!);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MenuScreen()),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Выбрать',
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionCard({
    required RestaurantInfo res,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    IconData icon;
    String typeText;
    switch (res.type) {
      case 'cafe':
        icon = Icons.coffee;
        typeText = 'Кофейня';
        break;
      case 'fastfood':
        icon = Icons.fastfood;
        typeText = 'Фастфуд';
        break;
      default:
        icon = Icons.restaurant;
        typeText = 'Ресторан';
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: isSelected ? AppColors.accent : AppColors.divider,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.chipBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: isSelected ? AppColors.accent : AppColors.textSecondary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.name,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? AppColors.accent : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      typeText,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle, color: AppColors.accent),
            ],
          ),
        ),
      ),
    );
  }
}
