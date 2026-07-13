import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/restaurant_provider.dart';
import 'package:restaurant/screens/scan_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Инициализация Supabase
  // ЗАМЕНИТЕ ЭТИ ЗНАЧЕНИЯ НА ВАШИ ИЗ НАСТРОЕК SUPABASE (Settings -> API)
  await Supabase.initialize(
    url: 'https://rpfhpgapasjrpxsvnjej.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJwZmhwZ2FwYXNqcnB4c3ZuamVqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM5Mzg1NTUsImV4cCI6MjA5OTUxNDU1NX0.2MMxwmVuWQJvXCkTxFKrRJI2ngXomvAzoqRvpHe04AE',
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const LartCulinaireApp(),
    ),
  );
}

class LartCulinaireApp extends StatelessWidget {
  const LartCulinaireApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,

        title: "L'Art Culinaire",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        home: const ScanScreen(),
      ),
    );
  }
}
