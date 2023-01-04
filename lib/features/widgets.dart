import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/food_inventory.dart';
import 'package:save_my_food/theme.dart';

import 'product.dart';
import 'profile.dart';

class WidgetsPage extends StatelessWidget {
  final Function(int) navigateTo;

  const WidgetsPage({Key? key, required this.navigateTo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Profile profile = context.read<Profile>();
    return Container(
      color: HexColor.pink.get(),
      padding: const EdgeInsets.only(left: 40, right: 40, top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset('assets/images/logo.png', width: 160),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              ButtonWidget(
                text: 'Inventory',
                image: 'assets/images/inventory.png',
                offset: Offset(3, 0),
              ),
              SizedBox(width: 20),
              ButtonWidget(
                text: 'Scan receipt',
                image: 'assets/images/scan.png',
                offset: Offset(3, 0),
              ),
            ],
          ),
          const SizedBox(height: 20),
          NormalWidget(
            text: 'Products that expire soon:',
            children: [
              const SizedBox(height: 15),
              ...profile.expireSoon
                  .map((product) => ExpiresSoonItem(product: product))
            ],
          ),
          const SizedBox(height: 20),
          const NormalWidget(
            text: 'Progress quantified:',
            children: [
              SizedBox(height: 15),
              NormalText(
                  'You have wasted approx. 1 kg of food items this month.',
                  size: 16),
              SizedBox(height: 15),
              NormalText(
                  'It would take a tree 2 months to negate this waste. Be more careful with your food waste!',
                  size: 16),
            ],
          ),
        ],
      ),
    );
  }
}

class ExpiresSoonItem extends StatelessWidget {
  final Product product;

  const ExpiresSoonItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        children: [
          NormalText(product.name, color: Colors.black, size: 16),
          const Spacer(),
          DaysLeft(product.daysLeft, scale: 0.8),
        ],
      ),
    );
  }
}

class NormalWidget extends StatelessWidget {
  final List<Widget> children;
  final String text;

  const NormalWidget({
    required this.text,
    required this.children,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WidgetBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetText(text),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final String image;
  final Offset offset;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.image,
    this.offset = Offset.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: WidgetBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: offset,
              child: Image.asset(image, height: 90),
            ),
            WidgetText(text),
          ],
        ),
      ),
    );
  }
}

class WidgetBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double? height;

  const WidgetBox({
    Key? key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.height = 190,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(25),
      elevation: 10,
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class WidgetText extends StatelessWidget {
  final String text;

  const WidgetText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalText(text,
        size: 20, color: HexColor.red.get(), weight: FontWeight.w700);
  }
}
