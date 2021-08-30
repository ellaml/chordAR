import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:flutter_complete_guide/chord_notes.dart';
import 'package:flutter_complete_guide/settings/chords_voice_recognition.dart';
import 'package:flutter_complete_guide/utils.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter_complete_guide/globals.dart' as globals;


enum CameraType
{
  ONE,
  TWO
}

class Camera extends StatefulWidget {
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> with WidgetsBindingObserver {
  CameraController _controller;
  CameraDescription _selectedCamera;
  CameraType _cameraType;
  double screenWidth, screenHeight;
  final _stackKey = GlobalKey();

  Timer _timer;
  List<Widget> listOfChordPointsWidgets = [];

  void _updateListOfChordPointWidgets() async {
    final RenderBox renderBox = this._stackKey.currentContext.findRenderObject();
    final cameraHeight = renderBox.size.height;
    final cameraWidth = renderBox.size.width;

    final topAddition = 80.0; //app bar
    final leftAddition = (this.screenWidth - cameraWidth) / 2; // centered
    XFile xfile = await _controller?.takePicture();
    if(globals.isMicTurnedOn)
    {
        if(globals.chord != "")
        {
          print("Hiii the chord is: " + globals.chord);
          listOfChordPointsWidgets = await createNoteWidgetsByFrame(globals.chord, xfile.path, topAddition, leftAddition, cameraWidth, cameraHeight);
        }
    }
    await removeFile(xfile.path);
  }

  void _saveImgToGallery() async {
    XFile xfile = await _controller?.takePicture();
    await ImageGallerySaver.saveFile(xfile.path); //Save Image to Gallery
    await removeFile(xfile.path);
  }

  @override
  void initState() {
    super.initState();
    setupCamera();
    WidgetsBinding.instance.addObserver(this);
    _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      setState(() {
        _updateListOfChordPointWidgets();
      });
    });
    //_timer = Timer.periodic(Duration(seconds: 10), (Timer t) {
    //  _saveImgToGallery();
    //});
    //
    //Fix for length and not mirroring in tablet
    if(_cameraType == CameraType.TWO)
    {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    //End of Fix for length and not mirroring in tablet
  }

  @override
  void dispose() {
    //Fix for length and not mirroring in tablet
    if(_cameraType == CameraType.TWO)
    {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
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
    this.screenHeight = screenData.screenHeight;
    this.screenWidth = screenData.screenWidth;

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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SpeechScreen(),
        body: _controller == null
            ? Container(color: Colors.black)
            : Center(
          child: Stack(
            key: this._stackKey,
            children: [
             /* Positioned(
                  child: Container(height:20, width:40, child: Text(globals.chord, style: TextStyle(fontSize: 30, color: Colors.green))),
                  left: screenWidth / 2,
                  top: 0
              )*/
              Align(
                alignment: Alignment.topRight,
                child: Text(globals.chord),
              ),
              //CameraPreview(_controller),
              Image.asset('assets/images/a.jpeg'), //Testing static image
              ...listOfChordPointsWidgets,  //TODO
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
          _cameraType = CameraType.TWO;
          _selectedCamera = data[1];
        }
        else {
          print("one camera");
          _cameraType = CameraType.ONE;
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