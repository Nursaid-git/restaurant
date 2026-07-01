import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_preview/device_preview.dart';

import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/screens/cart_screen.dart';
import 'package:restaurant/screens/menu_screen.dart';
import 'package:restaurant/screens/scan_screen.dart';
import 'package:restaurant/theme/app_theme.dart';
import 'widgets/bottom_nav_bar.dart';

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
        home: const MenuScreen(),
      ),
    );
  }
}

/// Корневой экран с нижней навигацией.
/// Меню, Заказы, Корзина и Профиль живут внутри одного IndexedStack,
/// а состояние корзины (CartProvider) общее для всех — так имитируется
/// "взаимодействие" экранов друг с другом без какого-либо бэкенда.
class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentIndex = 0;

  void _goToTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    final screens = [
      const MenuScreen(),
      const _PlaceholderScreen(title: 'Заказы', subtitle: 'История заказов появится здесь'),
      CartScreen(onAddDish: () => _goToTab(0)),
      const _PlaceholderScreen(title: 'Профиль', subtitle: 'Раздел в разработке'),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _goToTab,
      ),
    );
  }
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  const _PlaceholderScreen({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(subtitle, style: const TextStyle(color: AppColors.textSecondary)),
      ),
    );
  }
}
