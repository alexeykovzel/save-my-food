import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/routes.dart';

import 'saved_products.dart';
import 'product_list.dart';
import 'product_view.dart';

class FoodInventoryPage extends StatelessWidget {
  const FoodInventoryPage({Key? key}) : super(key: key);

  void openAddProduct(BuildContext context) {
    Routes.pushRightLeft(
      context,
      ProductViewPage(
        onSave: (context, product) {
          context.read<SavedProducts>().add(product);
          Navigator.pop(context);
        },
        saveText: 'Create',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavedProducts>(
      builder: (context, products, child) => ProductListPage(
        title: 'Food Inventory',
        products: products.all,
        onRemove: products.remove,
        floatingButton: MainFloatingButton(
          onPressed: () => openAddProduct(context),
          text: 'Add product',
        ),
        onEdit: (product, newProduct) {
          context.read<SavedProducts>().swap(product, newProduct);
        },
      ),
    );
  }
}
