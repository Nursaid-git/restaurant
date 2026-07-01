import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/screens/scan_screen.dart';
import 'package:restaurant/theme/app_theme.dart';

void main() {
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