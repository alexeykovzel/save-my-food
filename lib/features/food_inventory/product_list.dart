import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/routes.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/food_inventory/product_view.dart';
import 'package:save_my_food/features/food_inventory/saved_products.dart';
import 'package:save_my_food/features/home.dart';
import 'package:save_my_food/features/settings/settings.dart';
import 'package:save_my_food/theme.dart';

import 'product.dart';

class ProductListPage extends StatelessWidget {
  final String title;
  final List<Product> products;
  final Widget floatingButton;
  final Function(Product) onRemove;
  final Function()? onClose;

  const ProductListPage({
    Key? key,
    required this.title,
    required this.products,
    required this.floatingButton,
    required this.onRemove,
    this.onClose,
  }) : super(key: key);

  void onEdit(BuildContext context, Product product) {
    Routes.pushRightLeft(
      context,
      ProductViewPage(
        saveText: 'Confirm',
        expirationDate: DateFormat('yyyy-MM-dd').format(product.expiresBy),
        productName: product.name,
        quantity: product.quantity,
        onSave: (context, newProduct) {
          context.read<SavedProducts>().edit(product, newProduct);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _rowView(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            SizedBox(width: 30),
            FieldName('Product name'),
            Spacer(),
            FieldName('Days Left'),
            SizedBox(width: 50),
          ],
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          child: Column(
            children: [
              ...products.map(
                (product) => ProductRow(
                  product: product,
                  onDelete: () => onRemove(product),
                  onEdit: () => onEdit(context, product),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _cardView(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (BuildContext context, int index) {
        return ProductCard(
          product: products[index],
          onEdit: () => onEdit(context, products[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    products.sort((a, b) => a.daysLeft < b.daysLeft ? 0 : 1);
    return Consumer<Settings>(
      builder: (context, settings, child) => NormalLayout(
        title: title,
        floating: [
          floatingButton,
          Padding(
            padding: const EdgeInsets.only(top: 80, right: 20),
            child: Align(
              alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ToggleViewButton(
                    size: 24,
                    onPressed: () => context.read<Settings>().toggleView(),
                    icon: Icons.grid_view,
                    isOn: settings.cardView,
                  ),
                  const SizedBox(width: 8),
                  ToggleViewButton(
                    size: 28,
                    onPressed: () => context.read<Settings>().toggleView(),
                    icon: Icons.view_list,
                    isOn: !settings.cardView,
                  ),
                ],
              ),
            ),
          )
        ],
        contentPadding: EdgeInsets.zero,
        onClose: onClose,
        content: settings.cardView ? _cardView(context) : _rowView(context),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;
  final Function() onEdit;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onEdit,
  }) : super(key: key);

  Color getColor(int daysLeft) {
    if (daysLeft <= 4) return HexColor.pink.get();
    if (daysLeft <= 10) return HexColor.yellow.get();
    return HexColor.green.get();
  }

  @override
  Widget build(BuildContext context) {
    int daysLeft = product.daysLeft;
    return InkWell(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: getColor(daysLeft), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 15),
              Image.network(
                product.image ??
                    'https://cdn-icons-png.flaticon.com/512/5184/5184592.png',
                height: 80,
              ),
              const Spacer(),
              NormalText(
                product.name,
                weight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
              NormalText('$daysLeft days left', size: 12),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductRow extends StatelessWidget {
  final Product product;
  final Function() onDelete;
  final Function() onEdit;

  const ProductRow({
    Key? key,
    required this.product,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String productName =
        '${product.quantity > 99 ? '99+' : product.quantity.toString()} '
        '${product.name}';
    return InkWell(
      onTap: onEdit,
      child: Row(
        children: [
          const SizedBox(width: 30),
          NormalText(
            productName.length > 20
                ? '${productName.substring(0, 20)}...'
                : productName,
            size: 18,
          ),
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
      ),
    );
  }
}

class ToggleViewButton extends StatelessWidget {
  final Function() onPressed;
  final IconData icon;
  final double size;
  final bool isOn;

  const ToggleViewButton({
    Key? key,
    required this.size,
    required this.onPressed,
    required this.icon,
    required this.isOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 4,
      child: SizedBox(
        width: 35,
        height: 35,
        child: IconButton(
          padding: EdgeInsets.zero,
          highlightColor: Colors.white,
          onPressed: onPressed,
          splashRadius: 22,
          icon: Icon(
            icon,
            color: isOn ? HexColor.pink.get() : HexColor.gray.get(),
            size: size,
          ),
        ),
      ),
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
