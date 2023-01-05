import 'package:flutter/material.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/home.dart';
import 'package:save_my_food/theme.dart';

import 'product.dart';

class ProductListPage extends StatelessWidget {
  final String title;
  final List<Product> products;
  final Function(Product) onItemRemove;
  final Widget floatingButton;
  final Function()? onClose;

  const ProductListPage({
    Key? key,
    required this.title,
    required this.products,
    required this.onItemRemove,
    required this.floatingButton,
    this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    products.sort((a, b) => a.daysLeft < b.daysLeft ? 0 : 1);
    return NormalLayout(
      title: title,
      floating: floatingButton,
      floatingPadding: const EdgeInsets.only(bottom: 30),
      onClose: onClose,
      children: [
        Row(
          children: const [
            FieldName('Product name'),
            Spacer(),
            FieldName('Days Left'),
            SizedBox(width: 50),
          ],
        ),
        const SizedBox(height: 10),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...products.map((product) => ProductItem(
                      product: product,
                      onDelete: () => onItemRemove(product),
                    ))
              ],
            ),
          ),
        )
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
            splashRadius: 22,
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
  final double scale;

  const DaysLeft(
    this.value, {
    Key? key,
    this.scale = 1,
  }) : super(key: key);

  Color getColor() {
    if (value <= 4) return HexColor.pink.get();
    if (value <= 10) return HexColor.yellow.get();
    return HexColor.green.get();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 62,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: getColor(), width: scale < 1 ? 3 : 2),
        ),
        child: Center(
          child: NormalText(value > 99 ? '99+' : value.toString()),
        ),
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