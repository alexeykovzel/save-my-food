import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/features/product/inventory.dart';
import 'package:save_my_food/features/product/product.dart';
import 'package:save_my_food/features/product/product_list.dart';

class ConfirmScanPage extends StatelessWidget {
  final List<Product> products;
  final Function() onInventory;

  static const route = '/confirm_scan';

  const ConfirmScanPage({
    Key? key,
    required this.products,
    required this.onInventory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProductListPage(
      title: 'Food Inventory',
      products: products,
      onItemRemove: (product) {},
      floatingButton: FloatingButton(
        text: 'Confirm',
        onPressed: () {
          context.read<Inventory>().products.addAll(products);
          onInventory();
          Navigator.pop(context);
        },
      ),
    );
  }
}
