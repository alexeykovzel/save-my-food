import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/loading.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/food_inventory/product.dart';

import 'receipt_scanner.dart';

class ScanReceiptPage extends StatelessWidget {
  const ScanReceiptPage({Key? key}) : super(key: key);

  Future<CameraController> initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    final controller = CameraController(cameras[0], ResolutionPreset.max);
    await controller.initialize();
    return controller;
  }

  void scanReceipt(CameraController camera) {
    camera.startImageStream((image) async {
      List<Product> products = await ReceiptScanner.scan(image);

      // TODO: Navigate to 'confirm products'.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 90, left: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Heading('Scan the receipt'),
              SizedBox(height: 20),
              NormalText(
                  'Scan the receipt with your products and their prices.'),
            ],
          ),
        ),
        Expanded(
          child: LoadingHandler(
            future: initCamera,
            loading: () => const CircularLoading(),
            builder: (_, camera) => Stack(
              children: [
                Positioned.fill(child: CameraPreview(camera)),
                const Corner(image: 'corner-1.svg', top: 30, left: 40),
                const Corner(image: 'corner-2.svg', top: 30, right: 40),
                const Corner(image: 'corner-3.svg', bottom: 30, left: 40),
                const Corner(image: 'corner-4.svg', bottom: 30, right: 40),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: FloatingButton(
                    text: 'Confirm',
                    onPressed: () => scanReceipt(camera),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Corner extends StatelessWidget {
  final String image;
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;

  const Corner({
    Key? key,
    required this.image,
    this.top,
    this.right,
    this.bottom,
    this.left,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: SvgPicture.asset('assets/images/corners/$image'),
    );
  }
}
