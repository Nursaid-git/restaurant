import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/screens/scan_screen.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://rpfhpgapasjrpxsvnjej.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwZmhwZ2FwYXNqcnB4c3ZuamVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM5Mzg1NTUsImV4cCI6MjA5OTUxNDU1NX0.2MMxwmVuWQJvXCkTxFKrRJI2ngXomvAzoqRvpHe04AE',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ],
      child: DevicePreview(
        enabled: !kIsWeb && !kReleaseMode,
        builder: (context) => const LartCulinaireApp(),
      ),
    ),
  );
}

class LartCulinaireApp extends StatefulWidget {
  const LartCulinaireApp({super.key});

  @override
  State<LartCulinaireApp> createState() => _LartCulinaireAppState();
}

class _LartCulinaireAppState extends State<LartCulinaireApp> {
  bool _isInitializing = true;
  bool _hasTableId = false;

  @override
  void initState() {
    super.initState();
    _handleIncomingLink();
  }

  Future<void> _handleIncomingLink() async {
    final params = Uri.base.queryParameters;
    final tableId = params['tableId'];

    if (tableId != null && tableId.isNotEmpty) {
      _hasTableId = true;
      // Теперь провайдер доступен сразу, так как он выше в дереве
      final provider = context.read<RestaurantProvider>();
      final success = await provider.setByTableId(tableId);
      
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } else {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Пока загружаем данные из QR-ссылки, показываем заставку
    if (_isInitializing && _hasTableId) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: const Center(
            child: CircularProgressIndicator(color: AppColors.accent),
          ),
        ),
      );
    }

    return MaterialApp(
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      title: "L'Art Culinaire",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      // Если стол распознан из ссылки — идем в меню, если нет — открываем сканер
      home: _hasTableId ? const MenuScreen() : const ScanScreen(),
    );
  }
}
