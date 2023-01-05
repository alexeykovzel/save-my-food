import 'package:flutter/material.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/scan_receipt/scan_receipt.dart';
import 'package:save_my_food/features/settings/settings_view.dart';
import 'package:save_my_food/features/home_widgets.dart';
import 'package:save_my_food/theme.dart';

import 'food_inventory/food_inventory.dart';

class HomePage extends StatefulWidget {
  static const route = '/';

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Widget> _pages;
  int _selectedIndex = 0;

  void navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeWidgetsPage(
        onInventory: () => navigateTo(2),
        onScanReceipt: () => navigateTo(1),
      ),
      ScanReceiptPage(
        onInventory: () => navigateTo(2),
      ),
      const FoodInventoryPage(),
      const SettingsViewPage(),
    ];
  }

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

class NormalLayout extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final Widget? floating;
  final EdgeInsets? floatingPadding;
  final Function()? onClose;

  const NormalLayout({
    Key? key,
    required this.title,
    required this.children,
    this.floating,
    this.floatingPadding,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 90),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(title),
              const SizedBox(height: 40),
              ...children,
            ],
          ),
        ),
        if (floating != null)
          Padding(
            padding: floatingPadding ?? EdgeInsets.zero,
            child: floating!,
          ),
        if (onClose != null)
          Padding(
            padding: const EdgeInsets.only(right: 30, top: 40),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: onClose,
                icon: Icon(
                  Icons.close,
                  color: HexColor.pink.get(),
                  size: 40,
                ),
              ),
            ),
          ),
      ],
    );
  }
}