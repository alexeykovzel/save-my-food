import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:save_my_food/common/input.dart';
import 'package:save_my_food/common/loading.dart';
import 'package:save_my_food/common/media.dart';
import 'package:save_my_food/common/routes.dart';
import 'package:save_my_food/common/text.dart';
import 'package:save_my_food/features/scan_receipt/failed_scan.dart';

import 'confirm_scan.dart';
import 'receipt_scanner.dart';

class ScanReceiptPage extends StatelessWidget {
  final Function() onInventory;

  const ScanReceiptPage({
    Key? key,
    required this.onInventory,
  }) : super(key: key);

  Future<CameraController> initCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    final controller = CameraController(
      cameras[0],
      ResolutionPreset.veryHigh, //API doesn't allow higher
      enableAudio: false,
    );
    // controller.setFlashMode(FlashMode.off);
    await controller.initialize();
    return controller;
  }

  void scanReceipt(BuildContext context, CameraController camera) {
    Routes.pushRightLeft(
      context,
      Scaffold(
        backgroundColor: Colors.white,
        body: LoadingHandler(
          future: () async {
            await Future.delayed(Duration.zero, () {});
            XFile receipt = await camera.takePicture();
            return await ReceiptScanner.scan(receipt);
          },
          loading: () => const CircularLoading(),
          builder: (_, products) => products == null
              ? const FailedScanPage()
              : ConfirmScanPage(
                  scannedProducts: products,
                  onInventory: onInventory,
                ),
        ),
      ),
    );
  }

  List<Widget> buildCorners() {
    return [
      Positioned(top: 30, left: 40, child: SvgCorner.topLeft.get()),
      Positioned(top: 30, right: 40, child: SvgCorner.topRight.get()),
      Positioned(bottom: 30, left: 40, child: SvgCorner.bottomLeft.get()),
      Positioned(right: 40, bottom: 30, child: SvgCorner.bottomRight.get()),
    ];
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
              NormalText('Scan the receipt with your products '
                  'and their prices.'),
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
                ...buildCorners(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: MainFloatingButton(
                    text: 'Confirm',
                    onPressed: () => scanReceipt(context, camera),
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
