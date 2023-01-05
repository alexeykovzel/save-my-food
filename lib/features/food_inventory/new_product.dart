import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/home.dart';
import 'package:save_my_food/theme.dart';

import 'inventory.dart';
import 'product.dart';

class NewProductPage extends StatefulWidget {
  final Function() onClose;

  static const route = '/new_product';

  const NewProductPage({Key? key, required this.onClose}) : super(key: key);

  @override
  State<NewProductPage> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _expirationDate = TextEditingController();
  final _productName = TextEditingController();
  final _quantity = TextEditingController();

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
          onClose: widget.onClose,
          floating: FloatingButton(
            text: 'Create',
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return null;
              }
              int quantity = normalizeQuantity(_quantity.text);
              Product product = Product(
                _productName.text,
                expiresBy: DateTime.parse(_expirationDate.text),
                quantity: quantity,
              );
              context.read<Inventory>().products.add(product);
              widget.onClose();
            },
          ),
          floatingPadding: const EdgeInsets.only(bottom: 30),
          children: [
            Row(
              children: [
                InputField(
                  controller: _productName,
                  label: 'Product name',
                  hint: 'Beef',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product name';
                    }
                    return null;
                  },
                  flex: 3,
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
    );
  }
}

class DateInputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int flex;

  const DateInputField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.flex,
  }) : super(key: key);

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  @override
  void initState() {
    super.initState();
    widget.controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return InputField(
      label: widget.label,
      controller: widget.controller,
      flex: widget.flex,
      hint: widget.hint,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter date';
        }
        return null;
      },
      readOnly: true,
      onTap: () async {
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (date != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          setState(() => widget.controller.text = formattedDate);
        }
      },
    );
  }
}

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? type;
  final Function()? onTap;
  final String label;
  final String? hint;
  final bool readOnly;
  final int flex;

  const InputField({
    Key? key,
    required this.controller,
    required this.label,
    this.validator,
    this.onTap,
    this.type,
    this.hint,
    this.readOnly = false,
    this.flex = 1,
  }) : super(key: key);

  OutlineInputBorder border() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: HexColor.pink.get(),
        width: 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NormalText(label),
          const SizedBox(height: 10),
          SizedBox(
            height: 80,
            child: TextFormField(
              validator: validator,
              controller: controller,
              onTap: onTap,
              keyboardType: type,
              readOnly: readOnly,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0.8),
                hintText: hint,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                enabledBorder: border(),
                errorBorder: border(),
                border: border(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
