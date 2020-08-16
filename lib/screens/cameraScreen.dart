import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutterchatapplication/screens/clickedImage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraWidgetLogic extends StatefulWidget {
  static final String id = "Camera_Screen";
  @override
  _CameraWidgetLogicState createState() => _CameraWidgetLogicState();
}

class _CameraWidgetLogicState extends State<CameraWidgetLogic> {
  List<CameraDescription> cameras;
  CameraDescription selectedCamera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    cameraAvailability();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _controller != null
          ? _initializeControllerFuture = _controller.initialize()
          : null;
    }
  }

  cameraAvailability() async {
    cameras = await availableCameras();
    selectedCamera = cameras[0];

    _controller = CameraController(selectedCamera, ResolutionPreset.max);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Transform.scale(
                  scale: _controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: CameraPreview(_controller),
                    ),
                  ),
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FloatingActionButton(
            heroTag: "Capture Photo",
            child: Icon(Icons.camera),
            tooltip: "Capture Image",
            elevation: 10.0,
            onPressed: () async {
              try {
                await _initializeControllerFuture;

                final path = join((await getTemporaryDirectory()).path,
                    '${DateTime.now()}.png');

                await _controller.takePicture(path);

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowClickedPicture(
                              imagePath: path,
                            )));
              } catch (e) {
                print(e);
              }
            },
          ),
          FloatingActionButton(
              heroTag: "rear camera",
              child: Icon(Icons.camera_rear),
              onPressed: () {
                setState(() {
                  selectedCamera = cameras[1];
                });
              })
        ],
      ),
    );
  }
}
