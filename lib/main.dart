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
    // Даем системе время обработать URL в браузере
    Future.delayed(const Duration(milliseconds: 200), () {
      _handleIncomingLink();
    });
  }

  Future<void> _handleIncomingLink() async {
    String? tableId;

    if (kIsWeb) {
      final String fullUrl = Uri.base.toString();
      debugPrint('Deep processing URL: $fullUrl');
      
      // 1. Пытаемся взять стандартным способом
      tableId = Uri.base.queryParameters['tableId'];

      // 2. Если не вышло, ищем tableId в любой части строки через регулярное выражение
      if (tableId == null || tableId.isEmpty) {
        final regExp = RegExp(r'tableId=([^&/#?]+)');
        final match = regExp.firstMatch(fullUrl);
        tableId = match?.group(1);
      }
    }

    if (tableId != null && tableId.isNotEmpty) {
      debugPrint('Target table detected: $tableId. Loading data...');
      final provider = context.read<RestaurantProvider>();
      final success = await provider.setByTableId(tableId);
      
      if (mounted) {
        setState(() {
          _hasTableId = success;
          _isInitializing = false;
        });
      }
    } else {
      if (mounted) {
        setState(() => _isInitializing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Пока приложение проверяет ссылку, показываем стильный индикатор
    if (_isInitializing) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: Color(0xFFB95C1D)),
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
      // Если стол распознан из ссылки — идем сразу в меню, иначе — на скан
      home: _hasTableId ? const MenuScreen() : const ScanScreen(),
    );
  }
}
