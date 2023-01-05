import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/theme.dart';

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
      borderSide: BorderSide(color: HexColor.pink.get(), width: 2),
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
      readOnly: true,
      validator: (value) {
        return (value == null || value.isEmpty) ? 'Please enter date' : null;
      },
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
          minimumSize: const Size(170, 0),
          padding: const EdgeInsets.symmetric(
            vertical: 20,
            horizontal: 30,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: onPressed,
        child: NormalText(
          text,
          weight: FontWeight.bold,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
