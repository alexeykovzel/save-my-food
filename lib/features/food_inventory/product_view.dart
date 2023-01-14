import 'package:flutter/material.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/features/home.dart';

import 'product.dart';

class ProductViewPage extends StatefulWidget {
  final Function(BuildContext, Product) onSave;
  final String saveText;
  final String productName;
  final String expirationDate;
  final int quantity;

  const ProductViewPage({
    Key? key,
    required this.onSave,
    required this.saveText,
    this.productName = '',
    this.expirationDate = '',
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<ProductViewPage> createState() => _ProductViewPageState();
}

class _ProductViewPageState extends State<ProductViewPage> {
  final _formKey = GlobalKey<FormState>();
  final _expirationDate = TextEditingController();
  final _productName = TextEditingController();
  final _quantity = TextEditingController();

  @override
  void initState() {
    super.initState();
    _productName.text = widget.productName;
    _quantity.text = widget.quantity.toString();
  }

  int normalizeQuantity(String value) {
    if (value == '') return 1;
    int? quantity = int.tryParse(value);
    if (quantity == null || quantity < 1) return 1;
    return quantity;
  }

  void resetFields() {
    _expirationDate.clear();
    _productName.clear();
    _quantity.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: _formKey,
        child: NormalLayout(
          title: 'New product',
          onClose: () => Navigator.pop(context),
          floating: [
            MainFloatingButton(
              text: widget.saveText,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Product product = Product(
                    _productName.text,
                    expiresBy: DateTime.parse(_expirationDate.text),
                    quantity: normalizeQuantity(_quantity.text),
                  );
                  widget.onSave(context, product);
                }
              },
            ),
          ],
          content: Column(
            children: [
              Row(
                children: [
                  InputField(
                    controller: _productName,
                    label: 'Product name',
                    hint: 'Beef',
                    flex: 3,
                    validator: (value) {
                      return (value == null || value.isEmpty)
                          ? 'Please enter product name'
                          : null;
                    },
                  ),
                  const SizedBox(width: 20),
                  InputField(
                    controller: _quantity,
                    type: TextInputType.number,
                    label: 'Quantity',
                    hint: '1',
                  ),
                  const SizedBox(width: 30),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(height: 20),
                  DateInputField(
                    initialValue: widget.expirationDate,
                    controller: _expirationDate,
                    label: 'Expiration date',
                    hint: '2023-01-04',
                    flex: 3,
                  ),
                  const SizedBox(width: 50),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
