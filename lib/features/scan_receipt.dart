import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:save_my_food/common/loading.dart';

class ScanReceiptPage extends StatefulWidget {
  const ScanReceiptPage({Key? key}) : super(key: key);

  @override
  State<ScanReceiptPage> createState() => _ScanReceiptPageState();
}

class _ScanReceiptPageState extends State<ScanReceiptPage> {
  late List<CameraDescription> _cameras;
  late CameraController controller;

  @override
  void initState() {
    super.initState();

    // _cameras = await availableCameras();

    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('Camera access denied');
            break;
          default:
            print('Something went wrong');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // if (!controller.value.isInitialized) {
    //   return const Center(
    //     child: Text('ERROR'),
    //   );
    // }
    // return LoadingHandler(
    //   builder: (cameras) => CameraPreview(controller),
    // );
  }
}
