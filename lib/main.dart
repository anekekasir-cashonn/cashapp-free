import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cashapp_free/providers/index.dart';
import 'package:cashapp_free/screens/index.dart';
import 'package:cashapp_free/theme.dart';
import 'package:cashapp_free/utils/localization_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Load translations before the app starts so widgets can use `t()` immediately
  await LocalizationHelper().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          return MaterialApp(
            title: 'CashApp Free - POS Cashier',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.darkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onNavigate: _navigateToScreen),
      const ProductsScreen(),
      const PosScreen(),
      const HistoryScreen(),
      const SettingsScreen(),
    ];
  }

  void _navigateToScreen(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (isMobile) {
      return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: t('bottom_nav.home', Provider.of<SettingsProvider>(context).language),
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2),
              label: t('bottom_nav.products', Provider.of<SettingsProvider>(context).language),
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_cart_outlined),
              selectedIcon: Icon(Icons.shopping_cart),
              label: t('bottom_nav.pos', Provider.of<SettingsProvider>(context).language),
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_outlined),
              selectedIcon: Icon(Icons.receipt),
              label: t('bottom_nav.history', Provider.of<SettingsProvider>(context).language),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: t('bottom_nav.settings', Provider.of<SettingsProvider>(context).language),
            ),
          ],
        ),
      );
    } else {
      // Desktop/Tablet layout with sidebar
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: Text(t('bottom_nav.home', Provider.of<SettingsProvider>(context).language)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.inventory_2_outlined),
                  selectedIcon: Icon(Icons.inventory_2),
                  label: Text(t('bottom_nav.products', Provider.of<SettingsProvider>(context).language)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  selectedIcon: Icon(Icons.shopping_cart),
                  label: Text(t('bottom_nav.pos', Provider.of<SettingsProvider>(context).language)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.receipt_outlined),
                  selectedIcon: Icon(Icons.receipt),
                  label: Text(t('bottom_nav.history', Provider.of<SettingsProvider>(context).language)),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: Text(t('bottom_nav.settings', Provider.of<SettingsProvider>(context).language)),
                ),
              ],
            ),
            Expanded(
              child: _screens[_selectedIndex],
            ),
          ],
        ),
      );
    }
  }
}
