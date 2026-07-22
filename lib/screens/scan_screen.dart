import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/screens/qr_generator_screen.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // КНОПКА ГЕНЕРАТОРА В УГЛУ
          IconButton(
            icon: const Icon(Icons.qr_code_2, color: Colors.white, size: 28),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QrGeneratorScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) async {
              if (!isScanning) return;
              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                final String? code = barcode.rawValue;
                if (code != null) {
                  setState(() => isScanning = false);

                  // Сохраняем ссылки на навигатор и провайдер до начала асинхронной операции
                  final navigator = Navigator.of(context);
                  final restaurantProvider = context.read<RestaurantProvider>();
                  final scaffoldMessenger = ScaffoldMessenger.of(context);

                  final success = await restaurantProvider.setByTableId(code);
                  
                  if (success) {
                    navigator.pushReplacement(
                      MaterialPageRoute(builder: (context) => const MenuScreen()),
                    );
                  } else {
                    if (mounted) {
                      setState(() => isScanning = true);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text('Неверный QR-код'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  }
                }
              }
            },
          ),
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
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RestaurantSelectionScreen()),
                    );
                  },
                  child: const Text('Выбрать вручную', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
