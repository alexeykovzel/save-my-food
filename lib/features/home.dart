import 'package:flutter/material.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/food_inventory.dart';
import 'package:save_my_food/features/scan_receipt.dart';
import 'package:save_my_food/features/settings.dart';
import 'package:save_my_food/features/widgets.dart';
import 'package:save_my_food/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 2;

  final List<Widget> _pages = [
    const WidgetsPage(),
    const ScanReceiptPage(),
    const FoodInventoryPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10),
          ],
        ),
        child: BottomNavigationBar(
          onTap: (index) => setState(() => _selectedIndex = index),
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: HexColor.gray.get(),
          selectedItemColor: HexColor.pink.get(),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          selectedFontSize: 13,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Scan',
              icon: Icon(Icons.camera_alt),
            ),
            BottomNavigationBarItem(
              label: 'Inventory',
              icon: Icon(Icons.inventory),
            ),
            BottomNavigationBarItem(
              label: 'Settings',
              icon: Icon(Icons.settings),
            ),
          ],
        ),
      ),
    );
  }
}
