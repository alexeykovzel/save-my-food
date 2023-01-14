import 'package:flutter/material.dart';

class Heading extends StatelessWidget {
  final String value;

  const Heading(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalText(value, size: 24, weight: FontWeight.bold);
  }
}

class NormalText extends StatelessWidget {
  final String value;
  final Color color;
  final TextAlign? align;
  final FontWeight weight;
  final TextOverflow? overflow;
  final double? height;
  final double? size;

  const NormalText(
    this.value, {
    Key? key,
    this.color = Colors.black,
    this.align,
    this.weight = FontWeight.w400,
    this.height,
    this.size,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: align,
      style: TextStyle(
        fontWeight: weight,
        overflow: overflow,
        fontSize: size,
        height: height,
        color: color,
      ),
    );
  }
}
