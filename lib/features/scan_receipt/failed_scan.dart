import 'package:flutter/material.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/home.dart';

class FailedScanPage extends StatelessWidget {
  const FailedScanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NormalLayout(
      title: 'Scan Failed',
      onClose: () => Navigator.pop(context),
      floating: FloatingButton(
        text: 'Re-scan',
        onPressed: () => Navigator.pop(context),
      ),
      floatingPadding: const EdgeInsets.only(bottom: 40),
      children: const [
        Padding(
          padding: EdgeInsets.only(right: 50),
          child: NormalText(
            'We could not detect a receipt within the image you took.\n\n'
            'When scanning receipts, try to fit the receipt within the given guidelines..\n\n'
            'If the receipt can not fit - take a picture of the top of the receipt to do a partial scan.',
          ),
        ),
      ],
    );
  }
}
