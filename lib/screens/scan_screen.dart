import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/screens/restaurant_selection_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScanning = true;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scannerSize = (screenWidth * 0.7).clamp(200.0, 280.0);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Сканер камеры
          MobileScanner(
            onDetect: (capture) async {
              if (!isScanning) return;
              
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  setState(() => isScanning = false);
                  
                  // Пытаемся найти стол по ID из QR
                  final success = await context.read<RestaurantProvider>().setByTableId(code);
                  
                  if (success) {
                    if (mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MenuScreen()),
                      );
                    }
                  } else {
                    setState(() => isScanning = true);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Неверный QR-код столика'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                }
              }
            },
          ),

          // Затемнение вокруг области сканирования
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.5),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                ),
                Center(
                  child: Container(
                    width: scannerSize,
                    height: scannerSize,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Рамка сканера
          Center(
            child: Container(
              width: scannerSize,
              height: scannerSize,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.accent, width: 4),
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),

          // Текст сверху
          Positioned(
            top: MediaQuery.of(context).padding.top + 40,
            left: 20,
            right: 20,
            child: const Column(
              children: [
                Text(
                  'Наведите камеру',
                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Отсканируйте QR-код на вашем столике',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Кнопка ручного выбора снизу
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 40,
            left: 40,
            right: 40,
            child: Column(
              children: [
                if (!isScanning)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: CircularProgressIndicator(color: AppColors.accent),
                  ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestaurantSelectionScreen()),
                    );
                  },
                  child: const Text(
                    'Выбрать вручную',
                    style: TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
