import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/routes.dart';

import 'inventory.dart';
import 'product_list.dart';
import 'product_view.dart';

class InventoryViewPage extends StatelessWidget {
  const InventoryViewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Inventory>(
      builder: (context, inventory, child) => ProductListPage(
        title: 'Food Inventory',
        products: inventory.products,
        onItemRemove: inventory.removeProduct,
        floatingButton: FloatingButton(
          text: 'Add product',
          onPressed: () => Routes.pushRightLeft(
            context,
            ProductViewPage(
              onSave: (context, product) {
                context.read<Inventory>().addProduct(product);
                Navigator.pop(context);
              },
              saveText: 'Create',
            ),
          ),
        ),
      ),
    );
  }
}
