import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:restaurant/theme/app_theme.dart';

class QrGeneratorScreen extends StatefulWidget {
  const QrGeneratorScreen({super.key});

  @override
  State<QrGeneratorScreen> createState() => _QrGeneratorScreenState();
}

class _QrGeneratorScreenState extends State<QrGeneratorScreen> {
  List<Map<String, dynamic>> restaurants = [];
  List<Map<String, dynamic>> tables = [];
  String? selectedRestaurantId;
  Map<String, dynamic>? selectedTable;
  bool isLoading = true;

  // ВАЖНО: Используем маленькие буквы, как в адресе GitHub
  final String baseUrl = "https://nursaid-git.github.io/restaurant/";

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Имя таблицы в Supabase должно быть 'restaurants'
      final res = await Supabase.instance.client.from('restaurants').select();
      if (mounted) {
        setState(() {
          restaurants = List<Map<String, dynamic>>.from(res);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading restaurants: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadTables(String restaurantId) async {
    if (mounted) {
      setState(() {
        tables = [];
        selectedTable = null;
        isLoading = true;
      });
    }
    try {
      final res = await Supabase.instance.client
          .from('tables')
          .select()
          .eq('restaurant_id', restaurantId);
      if (mounted) {
        setState(() {
          tables = List<Map<String, dynamic>>.from(res);
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading tables: $e');
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String qrData = "";
    if (selectedTable != null) {
      // Формируем прямую ссылку для сканирования камерой
      qrData = "$baseUrl?tableId=${selectedTable!['id']}";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Генератор QR-ссылок', style: TextStyle(color: AppColors.accent)),
        centerTitle: true,
      ),
      body: isLoading && restaurants.isEmpty
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedRestaurantId,
                    hint: const Text('Выберите ресторан'),
                    items: restaurants.map((res) {
                      return DropdownMenuItem<String>(
                        value: res['id'].toString(),
                        child: Text(res['name'].toString()),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => selectedRestaurantId = val);
                        _loadTables(val);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  if (tables.isNotEmpty)
                    DropdownButtonFormField<Map<String, dynamic>>(
                      value: selectedTable,
                      hint: const Text('Выберите стол'),
                      items: tables.map((table) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: table,
                          child: Text('Стол ${table['table_number']}'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setState(() => selectedTable = val);
                      },
                    ),
                  const Spacer(),
                  if (selectedTable != null) ...[
                    const Text(
                      'QR-ссылка для стола:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${selectedTable!['table_number']} (${restaurants.firstWhere((r) => r['id'] == selectedRestaurantId)['name']})',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),
                    SelectableText(
                      qrData,
                      style: const TextStyle(fontSize: 11, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              spreadRadius: 5,
                            )
                          ],
                        ),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 220.0,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                ],
              ),
            ),
    );
  }
}
