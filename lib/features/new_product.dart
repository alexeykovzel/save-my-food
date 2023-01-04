import 'package:flutter/material.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/features/home.dart';

class NewProductPage extends StatelessWidget {
  final Function() onClose;

  const NewProductPage({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NormalLayout(
        title: 'New product',
        onClose: () {},
        floating: FloatingButton(text: 'Create', onPressed: () {}),
        children: [],
      ),
    );
  }
}
