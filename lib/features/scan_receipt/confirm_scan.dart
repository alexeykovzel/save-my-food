import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/features/food_inventory/saved_products.dart';
import 'package:save_my_food/features/food_inventory/product.dart';
import 'package:save_my_food/features/food_inventory/product_list.dart';

class ConfirmScanPage extends StatefulWidget {
  final List<Product> scannedProducts;
  final Function() onInventory;

  static const route = '/confirm_scan';

  const ConfirmScanPage({
    Key? key,
    required this.scannedProducts,
    required this.onInventory,
  }) : super(key: key);

  @override
  State<ConfirmScanPage> createState() => _ConfirmScanPageState();
}

class _ConfirmScanPageState extends State<ConfirmScanPage> {
  late final List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = widget.scannedProducts;
  }

  @override
  Widget build(BuildContext context) {
    return ProductListPage(
      title: 'Food Inventory',
      products: _products,
      onItemRemove: (product) => setState(() {
        _products.remove(product);
      }),
      floatingButton: FloatingButton(
        text: 'Confirm',
        onPressed: () {
          context.read<SavedProducts>().all.addAll(_products);
          widget.onInventory();
          Navigator.pop(context);
        },
      ),
    );
  }
}
