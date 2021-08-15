import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_complete_guide/chord_notes.dart';
import 'package:flutter_complete_guide/providers/chords_widgets.dart';
import 'package:provider/provider.dart';

import 'live_mode_screen.dart';

class Camera extends StatefulWidget {

  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  List<CameraDescription> _cameras;
  CameraController _controller;
  int _selected = 0;
  Timer _timer;
  List<Widget> listOfCordPointWidgets = [];

  void _updateListOfCordePointWidgets() async {
    XFile xfile = await _controller?.takePicture();
    listOfCordPointWidgets = await createNoteWidgetsByFrame(xfile.path);
    await removeFile(xfile.path);
  }
  @override
  void initState() {

    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _updateListOfCordePointWidgets();
      });
    });

  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    _timer.cancel();
    _timer = null;
    _controller?.dispose();
    super.dispose();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_controller == null || !_controller.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      setupCamera();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (_controller == null) {
      return Container(
          color: Colors.black,
        );
    } else {
      return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Text('Live Mode'),
              CameraPreview(_controller),
              ...listOfCordPointWidgets,
            ],
          ));
    }
  }

  Future<void> setupCamera() async {
    _cameras = await availableCameras();
    var controller = await selectCamera();
    setState(() => _controller = controller);
  }

  selectCamera() async {
    var controller = CameraController(_cameras[_selected], ResolutionPreset.low);
    await controller.initialize();
    return controller;
  }


  Future<void> removeFile(String filePath) async {
    final file = io.File(filePath);
    if (file.existsSync()) {
      await file.delete();
    }
  }
}
