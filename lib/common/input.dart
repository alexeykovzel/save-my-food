import 'package:flutter/material.dart';
import 'package:save_my_food/common/text.dart';

class FloatingButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const FloatingButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: NormalText(text, weight: FontWeight.bold, size: 20),
      ),
    );
  }
}
