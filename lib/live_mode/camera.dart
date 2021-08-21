import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/chord_notes.dart';
import 'package:flutter_complete_guide/utils.dart';

class Camera extends StatefulWidget {
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _controller;
  CameraDescription _selectedCamera;

  Timer _timer;
  List<Widget> listOfChordPointsWidgets = [];

  void _updateListOfChordPointWidgets() async {
    XFile xfile = await _controller?.takePicture();
    listOfChordPointsWidgets = await createNoteWidgetsByFrame(xfile.path);
    await removeFile(xfile.path);
  }

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
      setState(() {
        _updateListOfChordPointWidgets();
      });
    });
    //Fix for length and not mirroring in tablet
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //End of Fix for length and not mirroring in tablet
  }

  @override
  void dispose() {
    //Fix for length and not mirroring in tablet
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //End of Fix for length and not mirroring in tablet
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
    ScreenData screenData = ScreenData(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .backgroundColor,
          centerTitle: true,
          title: Text("Live Mode",
              style: TextStyle(
                  fontSize: screenData.isBigDevice ? 32 : 24,
                  color: Colors.white)),
          leading: IconButton(
              icon: Icon(Icons.chevron_left_rounded),
              iconSize: 40,
              onPressed: () => Navigator.pop(context)),
          automaticallyImplyLeading: true,
          elevation: 0,
        ),
        body: _controller == null
            ? Container(color: Colors.black)
            : Center(
          child: Stack(
            children: [
              CameraPreview(_controller),
              //Image.asset('assets/images/a.jpeg'), //Testing static image
              ...listOfChordPointsWidgets,
            ],
          ),
        ));
  }

  void setupCamera()
  {
    availableCameras().then((data) {
      setState(() {
        if (data.length >= 2) {
          print("two cameras");
          _selectedCamera = data[1];
        }
        else {
          print("one camera");
          _selectedCamera = data[0];
        }
        selectCamera().then((data) {
          _controller = data;
        });
      });
    });
  }

  selectCamera() async {
    var controller =
      CameraController(_selectedCamera, ResolutionPreset.ultraHigh);

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