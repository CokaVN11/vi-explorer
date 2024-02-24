import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../../screens/camera/image_preview.dart';
import '../../settings/sizes.dart';

// List<CameraDescription> cameras = [];

// Future<void> getAvailableCams() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   cameras = await availableCameras();
// }

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key, required this.cameras});
  final List<CameraDescription> cameras;
  @override
  State<CameraScreen> createState() => _CameraScreenState(cameras: cameras);
}

class _CameraScreenState extends State<CameraScreen> {
  _CameraScreenState({required this.cameras});
  final List<CameraDescription> cameras;

  late CameraController controller;
  ScrollController scrollController = ScrollController();
  bool clicked = false;
  bool frontCamera = false;
  bool flash = false;
  double _currentScale = 1.0;
  double _baseScale = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) async {
    _currentScale = (_baseScale * details.scale)
        .clamp(1.0, await controller.getMaxZoomLevel());

    setState(() {
      controller.setZoomLevel(_currentScale);
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      cameras[0],
      ResolutionPreset.low,
      enableAudio: false,
    );
    controller.initialize().then((_) {
      // controller.setZoomLevel(1.5);
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
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
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        height: Sizes.height(context),
        width: Sizes.width(context),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  width: 150,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color(0xffe8e6ea),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group,
                        color: Colors.black.withOpacity(0.8),
                        size: 20,
                      ),
                      const SizedBox(width: 7), // Add spacing between icon and text
                      Text(
                        "Bạn bè",
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              controller: scrollController,
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 5),
                    width: Sizes.width(context),
                    height: Sizes.height(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onDoubleTap: () {
                            changeCamera();
                          },
                          onScaleUpdate: _onScaleUpdate,
                          onScaleStart: _onScaleStart,
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            // margin: EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            width: Sizes.width(context),
                            height: Sizes.width(context),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CameraPreview(
                                controller,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Positioned(
                                      bottom: 10,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          // color: Colors.white.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              color: Colors.transparent,
                                              child: Center(
                                                child: Text(
                                                  _currentScale
                                                      .toStringAsFixed(1),
                                                  style: TextStyle(
                                                    color: Color.fromARGB(255, 255, 255, 255)
                                                        .withOpacity(0.8),
                                                    fontSize: 15.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(bottom: 18),
                          margin: const EdgeInsets.only(bottom: 50),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    await controller.setFlashMode(flash == false
                                        ? FlashMode.always
                                        : FlashMode.off);

                                    setState(() {
                                      flash = !flash;
                                    });
                                  },
                                  icon: Icon(
                                    flash
                                        ? Icons.flash_on_outlined
                                        : Icons.flash_off_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  )),
                              Container(
                                  alignment: Alignment.center,
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: Color(0xffFCB600), width: 5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        clicked = !clicked;
                                      });
                                      controller.takePicture().then((value) {
                                        // Navigator.push(context, MaterialPageRoute(builder: (context)=>ImagePreview(imagePath: value.path,)));
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => ImagePreview(
                                                  imagePath: value.path,
                                                  onSend: () {
                                                    setState(() {});
                                                  },
                                                ));
                                      });
                                    },
                                    onLongPress: () {
                                      setState(() {
                                        clicked = !clicked;
                                      });
                                    },
                                    child: AnimatedContainer(
                                      onEnd: () {
                                        setState(() {
                                          clicked = false;
                                        });
                                      },
                                      duration: Duration(milliseconds: 100),
                                      width: clicked ? 50 : 80,
                                      height: clicked ? 50 : 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        color: clicked
                                            ? Color(0xff47444c)
                                            : Colors.black.withOpacity(0.7),
                                      ),
                                    ),
                                  )),
                              IconButton(
                                  onPressed: () {
                                    changeCamera();
                                  },
                                  icon: const Icon(
                                    Icons.flip_camera_ios_outlined,
                                    color: Colors.black,
                                    size: 40,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  changeCamera() {
    controller = CameraController(
      cameras[frontCamera ? 0 : 1],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        frontCamera = !frontCamera;
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }
}
