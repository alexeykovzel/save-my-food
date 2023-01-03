import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/theme.dart';

import 'product.dart';
import 'profile.dart';

class FoodInventoryPage extends StatelessWidget {
  const FoodInventoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Profile>(
      builder: (context, profile, child) => ProductsPage(
        title: 'Food Inventory',
        products: profile.products,
        onItemDelete: profile.deleteProduct,
        floatingButton: FloatingButton(
          text: 'Add product',
          onPressed: () {
            // TODO: Navigate to 'new product' page.
          },
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final String title;
  final List<Product> products;
  final Function(Product) onItemDelete;
  final Widget? floatingButton;
  final Function()? onClose;

  const ProductsPage({
    Key? key,
    required this.title,
    required this.products,
    required this.onItemDelete,
    this.floatingButton,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Heading(title),
              const SizedBox(height: 35),
              Row(
                children: const [
                  FieldName('Product name'),
                  Spacer(),
                  FieldName('Days Left'),
                  SizedBox(width: 50),
                ],
              ),
              const SizedBox(height: 10),
              ...products.map(
                (product) => ProductItem(
                  product: product,
                  onDelete: () => onItemDelete(product),
                ),
              ),
            ],
          ),
        ),
        if (floatingButton != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: floatingButton,
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

class ProductItem extends StatelessWidget {
  final Product product;
  final Function() onDelete;

  const ProductItem({
    Key? key,
    required this.product,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NormalText(product.name, size: 18),
        const Spacer(),
        DaysLeft(product.daysLeft),
        const SizedBox(width: 8),
        SizedBox(
          width: 50,
          child: IconButton(
            onPressed: onDelete,
            icon: Icon(
              Icons.delete_forever,
              color: HexColor.pink.get(),
              size: 32,
            ),
          ),
        )
      ],
    );
  }
}

class DaysLeft extends StatelessWidget {
  final int value;

  const DaysLeft(this.value, {Key? key}) : super(key: key);

  Color getColor() {
    if (value <= 4) return HexColor.pink.get();
    if (value <= 10) return HexColor.yellow.get();
    return HexColor.green.get();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 62,
      height: 34,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: getColor(), width: 2),
      ),
      child: Center(
        child: NormalText(value > 99 ? '99+' : value.toString()),
      ),
    );
  }
}

class FieldName extends StatelessWidget {
  final String text;

  const FieldName(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: HexColor.lightPink.get(), width: 2),
        ),
      ),
      child: NormalText(text, size: 18),
    );
  }
}
